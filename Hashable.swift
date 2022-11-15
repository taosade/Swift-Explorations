// Example of a custom type conforming to 'Hashable'

struct MyModel: Hashable
{
	let title: String
	
	// hash(into:) - hashing function

	func hash(into hasher: inout Hasher)
	{
		hasher.combine(title)
	}
}
