class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https:melsman.github.iomlkit"
  url "https:github.commelsmanmlkitarchiverefstagsv4.7.10.tar.gz"
  sha256 "94b2a097dae8ca9c0111cd6f4b6b3114e0f53846345d49a7995d9976abd9ac94"
  license "GPL-2.0-or-later"
  head "https:github.commelsmanmlkit.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 sonoma:       "f2377eb6bc298f6d74952c162ac42a63ceaf065482d394618c7a3ae4ea9f2948"
    sha256 ventura:      "d892893970977c99a7dacfa4baf40125e5f3bbfe0fb98c2bf40dfe8f28741e76"
    sha256 monterey:     "5a2f3026a252bc8f692839d091c565fbddbea8e22769badc517b21f7c71c1ece"
    sha256 x86_64_linux: "6fdf329df0ef660895e2cbf172104b0a5bd0716118081c266789c83f5cbdf332"
  end

  depends_on "autoconf" => :build
  depends_on "mlton" => :build
  depends_on arch: :x86_64 # https:github.commelsmanmlkitissues115
  depends_on "gmp"

  def install
    system "sh", ".autobuild"
    system ".configure", "--prefix=#{prefix}"

    # The ENV.permit_arch_flags specification is needed on 64-bit
    # machines because the mlkit compiler generates 32-bit machine
    # code whereas the mlton compiler generates 64-bit machine
    # code. Because of this difference, the ENV.m64 and ENV.m32 flags
    # are not sufficient for the formula as clang is used by both
    # tools in a single makefile target. For the mlton-compilation of
    # sml-code, no arch flags are used for the clang assembler
    # invocation. Thus, on a 32-bit machine, both the mlton-compiled
    # binary (the mlkit compiler) and the 32-bit native code generated
    # by the mlkit compiler will be running 32-bit code.
    ENV.permit_arch_flags
    system "make", "mlkit"
    system "make", "mlkit_libs"
    system "make", "install"
  end

  test do
    (testpath"test.sml").write <<~EOS
      fun f(x) = x + 2
      val a = [1,2,3,10]
      val b = List.foldl (op +) 0 (List.map f a)
      val res = if b = 24 then "OK" else "ERR"
      val () = print ("Result: " ^ res ^ "\\n")
    EOS
    system "#{bin}mlkit", "-o", "test", "test.sml"
    assert_equal "Result: OK\n", shell_output(".test")
  end
end