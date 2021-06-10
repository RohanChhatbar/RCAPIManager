import Foundation

struct UserListDataModel : Codable {
	let page : Int?
	let per_page : Int?
	let total : Int?
	let total_pages : Int?
	let data : [Data]?
	let support : Support?

	enum CodingKeys: String, CodingKey {

		case page = "page"
		case per_page = "per_page"
		case total = "total"
		case total_pages = "total_pages"
		case data = "data"
		case support = "support"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		per_page = try values.decodeIfPresent(Int.self, forKey: .per_page)
		total = try values.decodeIfPresent(Int.self, forKey: .total)
		total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
		data = try values.decodeIfPresent([Data].self, forKey: .data)
		support = try values.decodeIfPresent(Support.self, forKey: .support)
	}

}
