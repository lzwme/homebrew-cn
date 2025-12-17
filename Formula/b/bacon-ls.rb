class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://ghfast.top/https://github.com/crisidev/bacon-ls/archive/refs/tags/0.25.0.tar.gz"
  sha256 "778daa6102df7223fa654816dc908cbe1593789645bc9af13d04ddc742a7ead6"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d552c8037a25d4bc994bd1ef3dcbe949feb04c10a2e53a49d1e85830e441613"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd8ba86ce931d529eae764ef9876c184d457c1f4ed1584f5543b9530204ccd9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1411879e47ed037ec56d098f6b356406f65d7a79cb873eb68f02a8437382d66c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b56ddff70a6eaf194fd1459eb9f2e9051cabb885a60b91ef27f2566476dfb0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d9ebbd7eb8a663f65c4ca9f7003ec6d6250377b33bc2b784da8c330589bc5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02596e0725647fc46f9581336271a7c3a605113d13a3fef75bc84be94747715e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/bacon-ls --version")

    init_json = <<~JSON
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

    Open3.popen3(bin/"bacon-ls") do |stdin, stdout, _|
      stdin.write "Content-Length: #{init_json.bytesize}\r\n\r\n#{init_json}"
      stdin.close

      assert_match(/^Content-Length: \d+/i, stdout.read)
    end
  end
end