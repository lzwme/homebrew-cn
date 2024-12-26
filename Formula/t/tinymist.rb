class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.12.14.tar.gz"
  sha256 "24bd7b64487158f41ca980066fff3b9b95b2d5367d364c62b23974f6a82cfd32"
  license "Apache-2.0"
  head "https:github.comMyriad-Dreamintinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "357df13e0b0ceb18c0fdad78a64c52819d0782ff6e91f9b259dbae438b7e9a30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5c8a5ea3162acf441e2a6d8b088261069da39bce6775fc6c0219413ee4a99e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90d6148c18044440a5b01cdff64868433276cf6dcb9719a50fa57b79c9016b49"
    sha256 cellar: :any_skip_relocation, sonoma:        "2730d64576b6d843bcad3ebd52c9813a0f3a9c3180b112425fe2bbe961094264"
    sha256 cellar: :any_skip_relocation, ventura:       "4949ce78d2d97b545016106290dff578adc508419d32345ea60feb58ac1f4901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eedb26ea21f8e0da134a0523f238e60fb4c7ed551d5247a29c87b94129bff473"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestinymist")
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
    output = IO.popen(bin"tinymist", "w+") do |pipe|
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