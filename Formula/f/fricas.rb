class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://ghfast.top/https://github.com/fricas/fricas/releases/download/1.3.13/fricas-1.3.13-full.tar.bz2"
  sha256 "dd4d5e06db0ba4a43a5bfb64e94f6c8d4b10e68ac65a77556891a6b24af148a2"
  license "BSD-3-Clause"
  revision 8

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "809eb24e91c8433eb6523a4bdb93aa36068ed663f6c5b8e8fbb182761dc5124f"
    sha256 cellar: :any, arm64_tahoe:       "f0941105fef3ef61b6a21aa146cd61975455e46d030be614452ef47d28496afa"
    sha256 cellar: :any, arm64_sequoia:     "81fad5ecfce5fe1ffb6d0f7e3c33f2f0f4de244814a77cc1334b3c58e07aaa57"
    sha256 cellar: :any, arm64_linux:       "a33911c14828611d258ddb7b57b632479a06148e18c59d84aab70aa56c3e7526"
    sha256 cellar: :any, x86_64_linux:      "ba5f3ae7eeaeb8a66891846ab48426cfad745a40bdddf0f64f31a5ec9db9cb92"
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
    args = %w[
      --with-lisp=sbcl
      --enable-lisp-core
      --enable-gmp
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