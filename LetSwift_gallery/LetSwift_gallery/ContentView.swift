//
//  ContentView.swift
//  LetSwift_gallery
//
//  Created by Hyun A Song on 8/26/24.
//

import SwiftUI
import WebKit

struct ContentView: View {
  @State private var searchText: String = ""
  @State private var videoData: VideoData = VideoData(year: 2023, items: [])
  @State private var selectedYear: String = "2023"
  private var years = ["2023", "2022", "2019", "2018", "2017", "2016"]
  
  private var filteredItems: [VideoItem] {
    if searchText.isEmpty {
      return videoData.items
    } else {
      return videoData.items.filter { $0.title.contains(searchText) || $0.description.contains(searchText) }
    }
  }
  
  var body: some View {
    NavigationView {
      VStack {
        SearchView(searchText: $searchText)
        
        YearKeywords(selectedYear: $selectedYear, years: years)
        
        VideoList(filteredItems: filteredItems)
          .onAppear {
            loadVideoData(for: selectedYear)
          }
          .onChange(of: selectedYear) { _, newYear in
            loadVideoData(for: newYear)
          }
      }
    }
  }
  
  private func loadVideoData(for year: String) {
    videoData = loadJSON(selectedYear: year)
  }
}

// MARK: - Search View
private struct SearchView: View {
  @Binding var searchText: String
  
  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.gray)
      
      TextField(
        text: $searchText,
        label: {
          Text("세션 이름을 검색해보세요")
            .foregroundStyle(.gray)
        }
      )
    }
    .padding(.horizontal, 18)
    .padding(.vertical, 12)
    .overlay(
      RoundedRectangle(cornerRadius: 30)
        .stroke(.gray, lineWidth: 1)
    )
    .padding(.horizontal, 15)
    .padding(.vertical, 18)
  }
}

// MARK: - Year Keyword
private struct YearKeywords: View {
  @Binding var selectedYear: String
  var years: [String]
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: true) {
      HStack(spacing: 10) {
        ForEach(years, id: \.self) { year in
          Text(year)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(Color.gray)
            .overlay(
              RoundedRectangle(cornerRadius: 30)
                .stroke(selectedYear == year ? Color.pink : Color.clear, lineWidth: 3)
            )
            .foregroundColor(selectedYear == year ? .pink : .white)
            .fontWeight(selectedYear == year ? .bold : .regular)
            .cornerRadius(30)
            .onTapGesture {
              selectedYear = year
            }
        }
      }
      .padding(.horizontal, 10)
    }
    .padding(.leading, 5)
    .padding(.bottom, 18)
  }
}

// MARK: - Video List
private struct VideoList: View {
  var filteredItems: [VideoItem]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: true) {
      VStack(spacing: 0) {
        ForEach(filteredItems) { item in
          NavigationLink(destination: VideoPlayerView(videoID: item.resourceId.videoId)) {
            VStack(spacing: 0) {
              Divider()
                .background(Color.gray.opacity(0.5))
              
              Spacer()
              
              HStack(alignment: .center) {
                AsyncImage(url: URL(string: item.thumbnails.medium.url)) { image in
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                } placeholder: {
                  Color.gray
                }
                .frame(width: 110, height: 80)
                .padding(.leading, 18)
                
                VStack(alignment: .leading) {
                  Text(item.title)
                    .font(.headline)
                    .padding(.vertical, 4)
                    .lineLimit(2)
                  Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                  Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 10)
                
                Spacer()
              }
              .padding(.horizontal, 18)
              
              Spacer()
            }
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
    }
  }
}

// MARK: - VideoPlayerView
private struct VideoPlayerView: View {
  var videoID: String
  
  var body: some View {
    WebView(url: URL(string: "https://www.youtube.com/watch?v=\(videoID)")!)
      .navigationTitle("Watch Video")
  }
}

// MARK: - WebView for Displaying YouTube Videos
struct WebView: UIViewRepresentable {
  var url: URL
  
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.load(URLRequest(url: url))
  }
}

// MARK: - LoadJson
fileprivate func loadJSON(selectedYear: String) -> VideoData {
  guard let url = Bundle.main.url(forResource: "playlist-"+selectedYear, withExtension: "json"),
        let data = try? Data(contentsOf: url),
        let videoData = try? JSONDecoder().decode(VideoData.self, from: data) else {
    fatalError("Failed to load or parse JSON")
  }
  return videoData
}

#Preview {
  ContentView()
}
