class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "a91305825a3df3e3b08ed1b244f4d29567f20df2d01638b4eea77183b287ac1a"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b3942db064dd05be0e6c6694deff5e3aaa96500a9377ff7125047b8eed563d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3126d8e5083b29c4461b3dd7f2dbdb4160a68a570d2c1030c92a3528a5afaaef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19ce1231c85d1f7e26652e2a6421103b5d7c7f465d914db701fbb83071c61f66"
    sha256 cellar: :any,                 arm64_linux:       "01a4b3fa9eefead475715b07a357af223b638bca3fa795ea90bdd4506f392072"
    sha256 cellar: :any,                 x86_64_linux:      "d8aac10ce72ba002aa2c74437292758a99ee3532a6713308712feb655e88bc52"
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