class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.12.16.tar.gz"
  sha256 "f50a13e3395a5b018664653151a81bf3e1b77b683154622e252ab485e680ef67"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02ca9b1565ac908b815e77851b9888a3c1eebc11a35059ff3be688ea1b3c1f9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb7eb980865f9f2924b9af170f9873411329539e64b95e2c0b2c40644e5aa2ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "563acd2a16d6cbe3c30b4f467cce59aa227f8bf61f6fd5cce25d56347dc8dba7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9285e9456cea3c4d2848244399d5ab05f087bcedbd95b7ab51c1202c4a75132b"
    sha256 cellar: :any_skip_relocation, ventura:       "59391a6c555c5a2b3b65b75ad06399da6830c0930dcec14197a4f92e78ee9d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c51712e18bbe0495c610e42e4ce9c3851b53cf6a8c05c181542303fcd6ac5e00"
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