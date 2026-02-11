class GitXet < Formula
  desc "Git LFS plugin that uploads and downloads using the Xet protocol"
  homepage "https://github.com/huggingface/xet-core"
  url "https://ghfast.top/https://github.com/huggingface/xet-core/archive/refs/tags/git-xet-v0.2.0.tar.gz"
  sha256 "551237dbed960265804c745d50531cc16d8f13fb31e1900c9c6e081bfab01874"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^git[._-]xet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "d19a2d239649bed6cf313f6b755ec25164bbc6e6b98c694917706f1c8fd0355c"
    sha256 cellar: :any, arm64_sequoia: "7565fcedcc0e1e9794a025ca5c75c5009ce13f1e978a0242ae34ac99342091ec"
    sha256 cellar: :any, arm64_sonoma:  "ffefa4605deff6255ef1b6e4a8788ecf62ae8c592d8c9d2483f506a9cd999f39"
    sha256 cellar: :any, sonoma:        "aabc9528af0da64b2794b766b28ca00366fc08828203332303406953d54d7f58"
    sha256               arm64_linux:   "3cb48b9ef8fbc8d19652d119e99aa2e3150365248afafbb237dd9d0a405e80f1"
    sha256               x86_64_linux:  "c4d91f1387405b1c95591bbc4f75549b80a05eaf2f0f904928c1702f1373ab94"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "git-lfs"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "git_xet")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-xet --version")
    system "git", "init"
    system "git", "xet", "track", "test"
    assert_match "test filter=lfs", (testpath/".gitattributes").read
  end
end