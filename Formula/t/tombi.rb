class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.16.tar.gz"
  sha256 "eb3a0aef793ed4d6877b3398b00f4c0ed5ecd610aac4b8ed71a36c6687dbafec"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e31b894bbb3075299a796f5d12e6aaf573e7651b7dd82f1bd9761b4088cb2c7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db0b039c0f8a2d9a96b9156e246678d3807b79aa73933af82807334968d52a68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9338893a5903aa034c8385683ed83fc86499c7bb494727a54ebc685fb6fce42"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac711a4499741a49d35341fcfbefd86e4f14e8c905f2d870f384590db14b8613"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93f8bbaf801dd4fd4030a7530f9e95d8cb842cdb30faae866c1eac2355145d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4d24d4b6a996f3476b2df2498e361c1be2e3b1bb5d22e7e3eec69e24d1cc024"
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