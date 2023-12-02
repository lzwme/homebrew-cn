class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://ghproxy.com/https://github.com/ott-lang/ott/archive/refs/tags/0.32.tar.gz"
  sha256 "c4a9d9a6b67f3d581383468468ea36d54a0097804e9fac43c8090946904d3a2c"
  license "BSD-3-Clause"
  head "https://github.com/ott-lang/ott.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd0f2fd9c600b741f4a67c547013f08904262e088af9c2bce6561f0e81c65118"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bcd637f28c7e9f35695e9c42f4f43085c61af9e2aa602ff27dc860a878bcba4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42c7e02e40e66fd3be87f2da780ceab61c2b2211b38a2f93a49d57ae844be70f"
    sha256 cellar: :any_skip_relocation, sonoma:         "91bc4fbcd4ba118ef1c2b5a7419c0791df3319784066cba6a3abe5137797ee91"
    sha256 cellar: :any_skip_relocation, ventura:        "866c6d30e404716a80a6903c02d981e00c638afc0648b81931302af9d8d9e3d8"
    sha256 cellar: :any_skip_relocation, monterey:       "04c5722ca0a6a51c3353e73a61dbab52e6fcf8aa7fd2171e459ff344ac27787c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80f076cb53a69044fd0007ccdae4998c2ed828ee432134c65a141a5bdb1a013a"
  end

  depends_on "ocaml@4" => :build

  def install
    system "make", "world"
    bin.install "bin/ott"
    pkgshare.install "examples"
    (pkgshare/"emacs/site-lisp/ott").install "emacs/ott-mode.el"
  end

  test do
    system "#{bin}/ott", "-i", pkgshare/"examples/peterson_caml.ott",
      "-o", "peterson_caml.tex", "-o", "peterson_caml.v"
  end
end