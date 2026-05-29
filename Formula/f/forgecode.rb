class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "0a6684308937a3d6e632de5ca309cb99ef86beac3b9d38efdfe08caca706a768"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62bf2146ed81a86ea2120b1f36c1339b6032b3284ae89504520d81b0e40d313c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83977cf913cc319bb323a1addb6d168227f98e1208a6d78d46672b892761f06e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9797abcad9f983b2c46508cf4700aec748082f38efb49e801a0bf94ea3982532"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1d6bd7e785a50f0b155cc00bfd97aea43b7dadd63c6a7a129918891d9c337e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d143825f6cedd85445239152f6a12c8103634735e024d2af6895f7cc707f05fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66bca26a15d58e9b3539390590f29c4c7223c44e86c7dedd52a87d4052b031b4"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end