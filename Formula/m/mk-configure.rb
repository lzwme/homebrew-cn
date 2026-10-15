class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.40.1/mk-configure-0.40.1.tar.gz"
  sha256 "aa685810e60838f24c225243f89d9f61efd2d9eba1ebf4c2f361c452686e861a"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ca1b1b6d144864ae8d9257167923eae61630a3850aee7e854674e00a233542a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b63da219e7bcc87ce10ba4af30e82635f87d3db6992a2c8ac018e4bc62793c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e933f9d30e60ec9c0c501053a59bcf1858a6e26d2d701183e21931a6445cfe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a7b25e4f5d04d236ebdb29d1576c107b7b9b4901b5a639a71bb71d436668eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e1f1b43c494096be65eff50c7e467a6a430f7814bdaad970a3ec205cf9b1e80f"
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentation/presentation.pdf"
  end

  test do
    system bin/"mkcmake", "-V", "MAKE_VERSION", "-f", File::NULL
  end
end