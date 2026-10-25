class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "f2a0969f08d7ea4aa6015df17eaa1f8bebcdf948bea3d68f2fc70ef5f934f631"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e39cfafa7ae6619a6a9a1c8589c882627de0205e4a687c29c0a6ed3a508adb7a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50d0d9e2d0c308405782c49c697cae3ab507c59bcd1a397a3f5f9a8506748351"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4e954c634533beb61d5570a1eb7416a75f564b5cf877553fe9086d3fe6d4ca25"
    sha256 cellar: :any,                 arm64_linux:       "94f5d23a725936d8a7476f9aafff1aebbba352f6d28b1743567be44f56f45fb6"
    sha256 cellar: :any,                 x86_64_linux:      "6dc9b43dd4e51e45f22131094de76f5e4ad468bffaf726bfea0bb62e16eb1088"
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