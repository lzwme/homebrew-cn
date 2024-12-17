class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.12.12.tar.gz"
  sha256 "f9cb474364d2f1e42a51a0c409b03e7f2482787f260d7a2ab6df71dce27b4d47"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "737692de0fb0863e5ddc26b15dc579f725a1f923c683f9db45b3b37aa385f8db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b34d737658685b4109b6e1203fef7d30a336d0e0acd85fa7bd29d6f937a2131"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da5e19ab363109efef139201e9a183c1f1084204e889e82f12d0218bb0d4de57"
    sha256 cellar: :any_skip_relocation, sonoma:        "37aa980369e03a820f03384a4f79b84e168f507853c4f15bc8d353682d61864f"
    sha256 cellar: :any_skip_relocation, ventura:       "7eb45249b4d76d81f4f508bb0878433898f059447ed8236d070536fa2bf0d042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f35ea212c2ddf47df68f3d74e95f60d6a9df6b325ea7ac1bd9b2e4745437ba4"
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