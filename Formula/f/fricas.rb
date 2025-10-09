class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  license "BSD-3-Clause"
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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "64703bf4baf959f9012dc8496cada512031b58b458f71c1aeb8773965bc18df5"
    sha256 cellar: :any,                 arm64_sequoia: "5bcff86fb77d75170fc7510cb6f4a085b3f11ff6cbda79bd46e8c1ee25a06e44"
    sha256 cellar: :any,                 arm64_sonoma:  "cb0c313b4aad8554ffc5599e29ea52b3d905135fff563214b0ecdcfdc1b5a56c"
    sha256 cellar: :any,                 sonoma:        "8d0b0b27639999be31040f8929acd4f5ab96a45df1aceaccc6a27c802784a169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96074a0daf94443dc1872dcfe28189e0594da59f5eab8355c82e47609100e6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0659521326a584d23e2901ef7088c8a23cc5a835f0c08642024505da1244abe5"
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