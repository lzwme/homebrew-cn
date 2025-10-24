class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.38.tar.gz"
  sha256 "f485c97ffb81765dc8994f4a81068898d7b28dac4f333af4f427420c570a899f"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "485abb01096a0a46e5970b23ac28ae059b7b9a26135196d790bd85994a608dd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7ef515c28cbc4787c3473bbcca9d0f6209da2f9e9fe86139acfda470841b4fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56f11cf97e618fe273b67036ae62a7e0df2f148456abb6f922db8edefe50642a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2112fe526db53ea85dcc59f4f9a08a29544fd7815d738a4d9c65b05ccee372d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61261eeefe5e347accdce663521c5f01f157e2a9c8b4746d9882707a611fe2b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "264c430c4845c3f709834e92f6ac81c296586e9a97d8f23c0d3a7fabea1c6541"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
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