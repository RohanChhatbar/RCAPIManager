import Foundation

struct Data : Codable {
	let id : Int?
	let email : String?
	let first_name : String?
	let last_name : String?
	let avatar : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case email = "email"
		case first_name = "first_name"
		case last_name = "last_name"
		case avatar = "avatar"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
		last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
		avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
	}

}
