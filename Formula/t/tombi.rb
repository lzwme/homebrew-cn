class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "7f97d6bfa52f1ecf5341866128a9917c842514d856209c8020a18c3f7270e15e"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e444d579b07d58bc10d47b0298caf2a303e7dbd4b02f079e51c72417dc7f58c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "249e9c13d282f606e0ee40a8e6a3fd56fa9743a01058a6bb8942fabf57b59f6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79434071ef53a15cc99c6730364be7d2223c8d9b8b8fa403c7c181dfd6a29844"
    sha256 cellar: :any_skip_relocation, sonoma:        "96b8e39e28fa97fe244b73bb0a5df9462b9a00fbbae58b33e4d44309bd17af96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "453dc5950f42cb3c4aae781ff4b932a0e77db2e858550f6bd2dc427a438fd4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d19b555e039606656041528bce5e6dab3e60c5896cf75d1537fb151cf736f6"
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