class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.11.14.tar.gz"
  sha256 "eda55d165c0de8f7978eeec5cad8c206af36dacb407e0118b94fb3eabe7204be"
  license "Apache-2.0"
  head "https:github.comMyriad-Dreamintinymist.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bd0515b57199a171d000c5553feaa6ba9663046b7efb67b43ef7748e3c5ad03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef1aeaf7adb0ccf11e86bbf1b59015cd7a1349a21e180c06dd93c5afe5ebbf0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99684c8cac021a2ab070c6dd3fdc9023bf51d0f28dacce1c7cfa63054638c3ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "2040215de72036a2bd98b2b570cd59a5a86ccf65a78f98417fe0e09cf813d49e"
    sha256 cellar: :any_skip_relocation, ventura:        "eb2c16b12c82d2658fbfe0935dc987f482cac212884bb94cc727a2db52c3d865"
    sha256 cellar: :any_skip_relocation, monterey:       "c5c604f807c4a76110063db67117a930ef17fa38ce2bcee2e95b6a7e889833d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "034593cdf434f01477d3789fcf22408ac95174d0512848f19e37dd543b05bd8a"
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