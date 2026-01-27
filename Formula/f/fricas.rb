class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/fricas/fricas.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/fricas/fricas/archive/refs/tags/1.3.12.tar.gz"
    sha256 "f201cf62e3c971e8bafbc64349210fbdc8887fd1af07f09bdcb0190ed5880a90"

    # Build fricas as a SBCL core file instead of standalone executable.
    # Avoid patchelf issue on Linux and codesign issue on macOS.
    patch do
      url "https://github.com/fricas/fricas/commit/4d7624b86b1f4bfff799724f878cf3933459507d.patch?full_index=1"
      sha256 "dbfbd13da8ca3eabe73c58b716dde91e8a81975ce9cafc626bd96ae6ab893409"
    end
    patch do
      url "https://github.com/fricas/fricas/commit/03e4e83288ea46bb97f23c05816a9521f14734b7.patch?full_index=1"
      sha256 "3b9dca32f6e7502fea08fb1a139d2929c89fe7f908ef73879456cbdd1f4f0421"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "abf9e9018419b356c136c10412fcaf51fd0e77697c5cc87c268ce1625bb2ed6b"
    sha256 cellar: :any,                 arm64_sequoia: "4211cba7854be0862f9b765af57dd42854e2b32dba4a65dbacc8ffe5d00d37e3"
    sha256 cellar: :any,                 arm64_sonoma:  "45c3b8c0d824edaca8f2c1fce7388b86a039bbc7b25100838c3db513e73b8080"
    sha256 cellar: :any,                 sonoma:        "0bac3e7d0f507d38f6ceebfd68baba0456175addd098e7a78ce5846291a460ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ff18b13ffa73ebf16619fb54ade2c619a26ecc7b05818051015d599fa1d3186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b766b70eb7b19006654af31259d48ce59486bdf1e7181da771656d3ab850a8a4"
  end

  depends_on "gmp"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxdmcp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "sbcl"
  depends_on "zstd"

  def install
    args = [
      "--with-lisp=sbcl",
      "--enable-lisp-core",
      "--enable-gmp",
    ]

    mkdir "build" do
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match %r{ \(/ \(pi\) 2\)\n},
      pipe_output("#{bin}/fricas -nosman", "integrate(sqrt(1-x^2),x=-1..1)::InputForm")
  end
end