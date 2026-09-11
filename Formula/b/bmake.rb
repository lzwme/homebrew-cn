class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20260824.tar.gz"
  sha256 "76c6253a592dd55741be0b14805b9f7e0eb8442004146a978f24b20f37d2cb72"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d08f365259cb0cc1688fc5d80079ae2a20e8d93749e08fea298df71fbcd2c9e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0fafa283d79b84abfe98173e057302e6f4265c45f77ff7e98ea8866d89839524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87d6db90757cc75eb24815824c15e595730c881446f6b82947cffa86f75f416f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "837db970b993aba0a96caf2320be5a8401c7454702c53c9dd50c6532de7a0319"
    sha256                               arm64_linux:       "4f4fe160a217e09fd77e2ffff23549b21b010e73ab7c214373ae80ce617c2c6b"
    sha256                               x86_64_linux:      "089abe3ab258dab87a7755637fca50c9c3cc23c2224f55ea2a9bb694a94b1526"
  end

  uses_from_macos "bc-gh" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    broken_tests = %w[shell-ksh]
    if OS.linux?
      # The sandbox denies reading "/", which these unit tests and "bmake -r -m /" need
      ENV["MK_AUTO_OBJ"] = "no"
      broken_tests += %w[dir opt-chdir opt-where-am-i varname-dot-curdir varname-dot-path]
    end
    ENV["BROKEN_TESTS"] = broken_tests.join(" ")

    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install"]
    system "sh", "boot-strap", *args
  end

  test do
    (testpath/"Makefile").write <<~MAKE
      all: hello

      hello:
      	@echo 'Test successful.'

      clean:
      	rm -rf Makefile
    MAKE
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end