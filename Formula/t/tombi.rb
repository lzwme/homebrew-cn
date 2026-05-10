class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "665a7881b0421f55ae7133c235f2a89b528800b9cb0f554662bffe715defbc73"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6cb485739c30d3ae8260e210427c377103fae67af85333bd4a326565040e158"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98c6fb94e831e6b6cf65b19ea1f0bf183306637e218c9d3fe296dd12de57e69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93f931198f32ef72098cc7bf71ea3d42e4e686e7e322076a3fce4260565c1f41"
    sha256 cellar: :any_skip_relocation, sonoma:        "58642f87cd33757974dc96e9dd6a7e80165eb0c83062a6eaad9fcc917168ceb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05cbb1e49ab5b11ef8bf1bf198fca2361c1c1a2eb78525d26467bc550814f70d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2de85c8ea7d8e1b1d5d1edd8527aeb7054613e5654f0cdf701af5d53d2511978"
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