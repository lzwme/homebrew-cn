class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.11.16.tar.gz"
  sha256 "10f2facdb8cb57b92f58502e90cf68b3dacdf5d6c01f116a67f080f3364ecadb"
  license "Apache-2.0"
  head "https:github.comMyriad-Dreamintinymist.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4aed5c98e8461f5d38c4b5978589acea88a9056c142a7f150bf78847b392b3fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52416d531a0b146c22250ef1079929e325431ec9c6caf232b8a0fd2335028ea2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42518f5117bac1d41244692d8fe1ad948e020d2885fd039af7d763c4f08fdf8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4be05c011cadff62be02f3b414a03785687d360c8d9e7a432b83addc24e53589"
    sha256 cellar: :any_skip_relocation, ventura:        "3c78109c2a7afda0236a764ea0dcf748ba1a24f3a3d3bc6c7de67d46a206b01f"
    sha256 cellar: :any_skip_relocation, monterey:       "20c3ec434b1ced0663a75ff954d6e762fd2b548f7dc1f1b668a29a7b425f3e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "249763aeea4e29d01c84a37cba8f725e581b0b66f3740dfc091085f3fe4d29b4"
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