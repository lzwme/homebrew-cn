class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.11.17.tar.gz"
  sha256 "9f756c3c2f1483f7d03a4b6d4e466f9981a9f58fb34ce01e2f5467ffb6069bef"
  license "Apache-2.0"
  head "https:github.comMyriad-Dreamintinymist.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66ad4bf647bd770437ff770855be63c4b76a32da42a4b710cc8262ac58f90eaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42b5d9421a0136cd194a09153ca877e1e52ba1dee197545b0e9a0a8971b90f6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ffe6b586f8017d2779d5bc54bfc970fc0a971ebe8d46f1aba79431edc6bfe13"
    sha256 cellar: :any_skip_relocation, sonoma:         "92227b5b8f2e6a1afa7f341d7447e19f00530ade74a5338f2c182b24c7922a4e"
    sha256 cellar: :any_skip_relocation, ventura:        "f4dcfa5cb31c93d53af60561e0cec16f03bf00b82d9f37f83acde04af6817bcc"
    sha256 cellar: :any_skip_relocation, monterey:       "bb0d4764d6b36a74e44fc9493f5841ced437eed449597472e7890d17563a6b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "168dc2bace6ce11b78ba10ca453ff75431cef1d3fec1328d035ae9511ca52b7b"
  end

  depends_on "rust" => :build

  def install
    cd "cratestinymist" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = IO.popen("#{bin}tinymist", "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(^Content-Length: \d+i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end