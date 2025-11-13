class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.47.tar.gz"
  sha256 "e046bf1097c84615c2e00198536b8e7c8d2c67c47bd4daa9b7a56fce45d33749"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76324ae055b633b84a18b302bef243bba6c6ce8b8ff7b80e9ffd88c4776f446a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95edff60fba425726de5883d604b14e5ed1630b6ae3e35726777c2373ff679a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e821232dc2a81736c4dd4fa93573bce8ba3fa61f7e8ee4b1bfdc0ec0995484f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e093a189ff01277c221ec9fcdc44dd601452ffdae4fba85623b4df2813af90e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "534f0606b821e88c3058468e5e1ef8a5a71ca66f09188725e80068d5e9e58180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "694eab8736ecc155ac913aa54e3c776159adb2024c539d68ed9048f32415dc57"
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