class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.15.tar.gz"
  sha256 "2900c58ed6dccdff490b0cc69bbe32bdfc3400cadebc7db46d4ba49e0ba48ab4"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "402c0ffb42051517a260cd868748b898385ff880a030c1e22386688f63da5d19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ded95978e87886f2261800291f825821b042d5e0eee8a26fc2db205e9ba01488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a84acaf6276ba947d71107811ca0454945968f8bd56cdab514c96dc9a2d7b253"
    sha256 cellar: :any_skip_relocation, sonoma:        "e233dfcab8530a640404d5e8c5931d9652c87902262886a3cbb024983d2de55c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a365c8517c66d649d339cc9335ebf6612935b17a9e4487314cee9c277b95d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2b5b7aec3f3560842e555cbe462f7e84ea2dc39fca91d5c8a8a15b88c0802f"
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