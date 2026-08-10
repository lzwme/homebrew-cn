class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "dd4d307b045190cd112da13af6f75cbf5f03fdf1fbb35b4011adfdc8d2edd42a"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bf4460be07c45a9f4e74fc44eaa6fe3635038d5d6ffb5ab378e7b163162e380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef02b111708289648cf871386b22e0749847bc066d6ffbc5ba92f5a6afa16ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85083e1db6716188878bf991002f1cd6517b8ef02fb87bc22be871e0f642d243"
    sha256 cellar: :any_skip_relocation, sonoma:        "01b6bf377f5be419a3c0ea254e5415dd5bfd6f25649275af2a1accad0caa64c5"
    sha256 cellar: :any,                 arm64_linux:   "fd80b464f92daf9c80f513cb6cb0d3286ecef4a5d48d81062f95a079b6d72732"
    sha256 cellar: :any,                 x86_64_linux:  "62e2e39d4deb73d0c1223d2fac18efe616c8446d4234c59209de041e6771c401"
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