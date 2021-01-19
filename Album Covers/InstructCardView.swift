//
//  InstructCardView.swift
//  Cover Buddy
//
//  Created by Théo Arrouye on 1/19/21.
//

import SwiftUI

struct InstructCard {
    var title : String
    var icon : String
    var bgCol : Color
    var steps : [String]
}

struct InstructCardView : View {
    @Environment(\.openURL) var openURL
    
    @State var currentCardIndex : Int = 0
    @Binding var cardInfo : InstructCard
    
    @State var showingInfo : Bool = false
    
    
    var body : some View {
        VStack(alignment: .leading) {
            HStack {
                Image(cardInfo.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                
                Text(cardInfo.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // For spotify only, little info popup explaining why they have to go through Desktop
                if (cardInfo.title == "Spotify (Mobile)") {
                    Button(action: {
                        self.showingInfo = true
                    }) {
                        Image(systemName: "info.circle")
                    }
                    .alert(isPresented: $showingInfo) {
                        Alert(title: Text("Why don't I see these options?"),
                            message: Text("Spotify's iOS app currently only supports editing playlist covers for a select number of users as part of an ongoing server-side rollout. If you believe you are included in this set of users, click on to see Spotify's instructions on how to use this feature from your phone."),
                            primaryButton: .default(Text("See Mobile Instructions")) {
                                openURL(URL(string: "https://newsroom.spotify.com/2020-12-08/how-to-upload-a-custom-playlist-image-using-your-phone/")!)
                            },
                            secondaryButton: .default(Text("OK")))
                    }
                }
                
            }
            
            CarouselView(cardCount: cardInfo.steps.count, currentIndex: $currentCardIndex, showPageDots: true, bgView: AnyView(
                    BackgroundBlurView()
                        .background(cardInfo.bgCol)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                )
            ) {
                ForEach(cardInfo.steps.indices) { step in
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Step \(step + 1)")
                                .font(.headline)
                                .padding(.bottom)

                                
                            
                            Text(cardInfo.steps[step])
                                .lineLimit(4)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                
                        }
                        
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .frame(height: 150)

        }
        .padding()
        .background(Color(UIColor.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        .padding()
    }
}
