class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.12.8.tar.gz"
  sha256 "69755c0b6561d18517361a9d90c636ba95f18e32bb23cd752f5658657189c340"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a93ca39a0782d91ae11390e8daff2236b6d056538f0eb354aee3274b209e6cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46ef52b24c9d3ce557977cdaf814223c6a14fcf6a56f042a0e0d1c8ca2d812c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc773169ddb34215d9c85e6cf05030f85c9eec4f049ad5be0f9412497d410a7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaebb4b11909573d985562e99c18ff34eeef130f5f62681d51c5088ce20e5bdb"
    sha256 cellar: :any_skip_relocation, ventura:       "f0b37b29c9a3a2643b1f9d9de5ef23739023463c04a01c8eb2c8daa838188551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9ebb0b1307714d8fa7cca2a53457cd54d0e84f3c5997f9991b28af842f24b54"
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