class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://ghfast.top/https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.6.tar.gz"
  sha256 "c49cbfc6ddb4abd3a2f74259b8272c72f86fc82090a887fa5b7c0b84b718a9ac"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff278c0bee12a5085f705be3d28f4187302adee42f46ae6317ba632c2809a6a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40283f96b35535c376991f82be3538e8d95e12a8a7ac6ec5668a5dbbf205d98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58fb6628aa1296fbfc257ab12efa3eddbbf42ee65e59871b12dfe5bff78f11b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "259fccfff1ccea85cb5775196c69726d9eccc7c2f2a654349cbd755eecf6555c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fbbe8cf6eeef94b9622f00505584675874a262bc5bf7233d866224f5a1c3c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "503b594d1606bc7c8ecd13cd1d012c9b734b6d49f5c2dd3113e1bec514730bb0"
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