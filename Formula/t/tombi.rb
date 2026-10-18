class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "c0618cb5129e79e342e1403d0ee86f402a4a50652c3dbb4d5a78b56d9ba9a7f3"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "af440128aa5ca6322738627c3ad25b3b5cb8f5f6a356e58816cba51b2da0c77f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d25fbaa36a8cb0a874aeb852ed81e3e7e08302c65dab483aedd0d5ae5c6b16e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "83b5a129279ef1a8844be3266e48ab3ba3286dda37127bdcf2b1a8ea26a80616"
    sha256 cellar: :any,                 arm64_linux:       "1424c56ac52202505f19f0757c96a35db03cc5698a63ed03ea3b665177f2a487"
    sha256 cellar: :any,                 x86_64_linux:      "e3b17dc759328430150f5a041952245e3e28e68d7e8177b1dd886547ae0d6418"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/tombi-cli/Cargo.toml"
  end

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