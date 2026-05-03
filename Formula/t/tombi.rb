class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "9bc1087aa33c246d31209a4fc659e1b9716cbd2c7b64a1209383692e95ae64d6"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7a00b34c0058ccbd551548ca0a4c744434c45c23462f520e68c90197775e539"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ef2cff93a00d478baf15a32bce18ee2061c1448db6a29ed60624912e9bc0599"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76ebc8845e923483ec5f84f827dab46b01453b910c834c028310ae65013fecb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "63559df76d84a139d77581fc0f4028e99f94fd509221cf8272375b496b2dc2cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "415ded5ab3deff23cf29c830e5842109bde9154546081e27495363bf72121ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3afb6479357922b33a30196847f132b954352817895f28716d6b346680a8a37"
  end

  depends_on "rust" => :build

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

    require "open3"

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

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end