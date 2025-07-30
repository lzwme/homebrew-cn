class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://ghfast.top/https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.16.tar.gz"
  sha256 "e97c018b452d864256ab3cdae34cfa77be6b3fffefc34fa63da08e0ca92f0125"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9544b726cef8369647c2692d53ad0d47dcf9433727d167b2420169a2b1c46f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5e3182b7102057904898dfad179a7ccb2c9938c0e9bc7470dc04edba092de17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1486f9ae1366b9bcb62952c462723f498bb6dde7556429856dadfaf3f6ec97e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed3b98a3d4c0af5cdea283f3b713f0026dfa697f7a401fda85bf85d41bb11c70"
    sha256 cellar: :any_skip_relocation, ventura:       "957271cae6e75d20ab168be4b754c13f8ee14b51c900fe681ee0d4c544a10268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3a766ff69b1b684e835cab6498f7bb698bae69be1d6f2ae7fe1eb88610aa505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47df195eec36c412a6e68aaba55ce63498b6f0ddc2017c742fcf598680c59016"
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