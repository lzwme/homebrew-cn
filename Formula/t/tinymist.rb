class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://ghfast.top/https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.18.tar.gz"
  sha256 "84ff7b3812dbe9c57a6cfb2844aea3c61282f94514767e956a1c3c65d1d66dac"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb2d5f57134f31ec1b805115db8b937843ff147283f3f1d08de705e0fd70d4d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "054b53b472c2e5e8265481d005b242511ec985185a07ae2fbcd28ccd2b9bd16f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "065ecc0b6418a98fe737a833ee1ea97ba44d5284297673fea93c4915dbd1a501"
    sha256 cellar: :any_skip_relocation, sonoma:        "b79742e324eaa0985a69b08feaae4d0a2bcf2e7bfcee08ddb49ae3594fe88101"
    sha256 cellar: :any_skip_relocation, ventura:       "13062e019bffb3cca87edd83b34db5ca66f94d77ce49227a35b9eaa321626ee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa6d57a5016c8e64a651098ce4d1e08ea1f8f0bcd6999415d230f6b9091480db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53d3d475db77c1197d33c6dcfeff20846e62bdd5ec126664983f5c243ebe38d8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist")
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
    output = IO.popen(bin/"tinymist", "w+") do |pipe|
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