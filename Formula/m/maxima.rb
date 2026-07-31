class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.49.0-source/maxima-5.49.0.tar.gz"
  sha256 "6d401a4aa307cd3a5a9cadca4fa96c4ef0e24ff95a18bb6a8f803e3d2114adee"
  license "GPL-2.0-only"
  revision 8

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c15450a1c6f14e107dadca4e952fc5cb4d7388ad64b7c9c6b7d20b3cc966d89d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79a5bacd64047548c0d77c5afbaf8f11e73a1ddadad3ea5492b20d7e1f260da2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e4d072f49e56a5c17229320cd571e29fd0688c24274f042d9bc8744a4d9b2bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c7a65f02798f3142bdd4f487e7bd75479dc4bc7c7a611b7982e43aebe213cc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca51017d306e936c06e21aad22a801f763405dff7acd9cfa36518f561971c2af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f669f1a7d93bb0fa4a76c3dbee5e1b34f4e1e84e427a47c365d872ebb6f2c354"
  end

  depends_on "gawk" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure", "--enable-gettext",
                          "--enable-sbcl",
                          "--with-emacs-prefix=#{elisp}",
                          "--with-sbcl=#{formula_opt_bin("sbcl")}/sbcl",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"maxima", "--batch-string=run_testsuite(); quit();"
  end
end