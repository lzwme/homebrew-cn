class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.11.11.tar.gz"
  sha256 "af050109f22bfd9d240f003bee467fa1fbbdb6b980a23beab6d8a5b5987a3fc0"
  license "Apache-2.0"
  head "https:github.comMyriad-Dreamintinymist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1db56952a2defb595a19f60a38c6e82060d8b2950c791d9626c3ecd8e976b239"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ca7302b90d8756e3247fb825cb6c97bcfb1c5f8d18e621ad15f55cb460c66d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "076d9ae68ed87828ba41acffcf03605092a4e3b65f6249ea0a8bf531a10a2c23"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e7079865e6de613bca5733f0cb82575bec43323b08f257c5a923880664dea23"
    sha256 cellar: :any_skip_relocation, ventura:        "90b9cc8286dadaa4b9e716a90f0fec4de0b9427ad8ecb730226021e93a974738"
    sha256 cellar: :any_skip_relocation, monterey:       "0413cc23ccf4743bc4eef03ee008d7b050f1f2bf3b23fefe204dbcf520d19e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "561e0b44c2815aa73eebea0a7d0216ce4bb118d51946d0b5d94a8f8c44bf721b"
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