class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "8ef0fc5ca78e21ccfd36f6e4ebf3e224395b7e59c4ed30546196754baa91d099"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a2708464bbb43272aa2aa1fbeba9e70a828d8aac83f72e4df98c24ecbc99e21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58664926e4597bb07209c31507b86fcbb1507b61c2ee3df08f0da4558a3dbbe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f188987d74b1bf360855a5b9157a6f3b42e89c6a291db30fe2d02ddfdd6ab38"
    sha256 cellar: :any_skip_relocation, sonoma:        "44425383c56cf42d4381f945a6f9a45e47e4aed507d72d2ff94674b4c46a2700"
    sha256 cellar: :any,                 arm64_linux:   "6526606e2356ba625307ecb5858e2b4d53403eedd96206932ede507edf03252a"
    sha256 cellar: :any,                 x86_64_linux:  "7726ec8392933ce1a7f58931a480a70be4cf4b2de9dc469ec118299c9317f3d2"
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