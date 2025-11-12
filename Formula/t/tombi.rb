class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.44.tar.gz"
  sha256 "230ac4d51b39c50867d8276b7d61946a6e78a82417cada85d44c8e48ca0055c8"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a287f7169ace6c7e41beb1dba17f70ec55009e8bbf19fa99206c10f14385692"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74ef038ffe81845eadd133d6cdabfdc8f0bd7b51f02065547649a4a770402325"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f115f86dad0dab7edd24610532d7fd9b4a9d4bb22619e0203cd9a0b13c511384"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ffd00b256f2973cea9f65997d971062eab554bde88bb58b7667decf9353f6d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fc3d3d074d2b407f84b2f0f436c6fbdc546b4f0583e795e7ca9608a0a306d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4744d0ecd35d3acc0e93b213bd3f1c322435c9cb7a484b4848c34b984f28181b"
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