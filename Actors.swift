// Using an actor shared among multiple views to achieve thread safety

import SwiftUI

actor ActorsDataManager
{
	static let instance = ActorsDataManager()

	private init() { }

	func getRandomString() -> String
	{
		// Access to this method is thread (async environment required)

		print(Thread.current)

		return UUID().uuidString
	}

	nonisolated func getNonIsolatedData() -> String
	{
		"Access to this string is not isolated"
	}
}

struct tab1: View
{
	let DM = ActorsDataManager.instance

	@State private var text: String = ""

	// Events published here can possibly interfere with second tab's events

	let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

	var body: some View
	{
		ZStack
		{
			Color.red.ignoresSafeArea(edges: .top)

			Text(text)
		}
		.onReceive(timer)
		{
			_ in Task // Async environment required to access actor's methods
			{
				let text = await DM.getRandomString()

				await MainActor.run { self.text = text }
			}
		}
	}
}

struct tab2: View
{
	let DM = ActorsDataManager.instance

	@State private var text: String = ""

	// Events published here can possibly interfere with first tab's events

	let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

	var body: some View
	{
		ZStack
		{
			Color.red.ignoresSafeArea(edges: .top)

			Text(text)
		}
		.onReceive(timer)
		{
			_ in Task // Async environment required to access actor's methods
			{
				let text = await DM.getRandomString()

				await MainActor.run { self.text = text }
			}
		}
	}
}

struct ActorsView: View
{
	var body: some View
	{
		TabView
		{
			tab1().tabItem { Label("Tab #1", systemImage: "house") }

			tab2().tabItem { Label("Tab #2", systemImage: "globe") }
		}

	}
}

struct 	ActorsView_Previews: PreviewProvider
{
	static var previews: some View
	{
		ActorsView()
	}
}
