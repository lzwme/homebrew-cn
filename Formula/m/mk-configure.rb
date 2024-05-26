class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https:github.comcheusovmk-configure"
  url "https:downloads.sourceforge.netprojectmk-configuremk-configuremk-configure-0.39.2mk-configure-0.39.2.tar.gz"
  sha256 "11e5f3fb0eaf0396146dece45f94cbf55a6a8ae3042b4d01f56e70821c333ba3"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]

  livecheck do
    url :stable
    regex(%r{url=.*?mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73a95b8c64c32e46e2ab17e56ace03a9eeaeed22933189b8d7a2f9cc53cfe00f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2938c921231a526633019e11447e3c082d8f44989ceb101376457aac4c092a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f379640de994c2cee5c78512ed9ff505e080b77dddc2838fbcc538f732dea70"
    sha256 cellar: :any_skip_relocation, sonoma:         "f78f701e834093d453795d9913a9ceaf761cb86c6157a625cd162b7e9db1dfba"
    sha256 cellar: :any_skip_relocation, ventura:        "4ea4f42c51e9cd8b21ab253dec8f1db6ec1c6477d2cc4e152efd90714a0f27f8"
    sha256 cellar: :any_skip_relocation, monterey:       "f2833ff0546be6cc01f82b54abd454945072a1042ea146ade0aafdfed1df3b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fce3fd1255ef29276a2e8cc0bd9728d73ee17c58fae38b158752110010c052e"
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentationpresentation.pdf"
  end

  test do
    system "#{bin}mkcmake", "-V", "MAKE_VERSION", "-f", "devnull"
  end
end