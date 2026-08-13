class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "ba3f173c94c51b9dbf9be3658e2a898c00f9e57963c5fe5a22ea3e0a4496db71"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4566305b04595ec3827f73d0dab41cdbf449f525aba4c372852e9e3616eec3ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a049c2f13d3969d98f9045423446cc25ff39417e1f88c4d6071fa494bc59f760"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c95812739bcea631aa7297fa38aeda480d4563827ddfe43526389e3927ca069c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5351020fcfa1afe75fb8c7439fcc2eb95f26560cea111e5427c190782c640a99"
    sha256 cellar: :any,                 arm64_linux:   "37ff67e06944c7ca375422df55014cfe7a727b13eef75002677d25514e84076c"
    sha256 cellar: :any,                 x86_64_linux:  "67dfb836bc1c4c0579733fcb4aa5b60f947be74a2f2f3682f6ea393a395da849"
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