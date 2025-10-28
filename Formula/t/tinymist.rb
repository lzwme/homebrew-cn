class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://ghfast.top/https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.30.tar.gz"
  sha256 "6324df76e0b560b8b89285425784d45e542bbe6eafab2044930c5103abe3cc52"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9eb04d81aaa75153d35bdd5680cb34ee7f6da8e4adec165e3359fa93a62ef60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d87934572ae012eeda3286838c42d99e2aca5c4480761716c779ee1dc64d5256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f678f13745d8b5214a07f1110542bc9545cdea734d6fc12f2503a5c84195c6b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5fd3990888df427396141f9b7079cba32a374eae9a95fa620f565c4ea57d789"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06c34115bb8136e3be2f8999d456e2180a2c81242cd83e042296093aab04c019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9c3ab1ae9ac810520e9b883a3d8ce2dd4150ac25c229a6f75809f719dcb3d91"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist-cli")
  end

  test do
    system bin/"tinymist", "probe"

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
    output = IO.popen([bin/"tinymist", "lsp"], "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(/^Content-Length: \d+/i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end