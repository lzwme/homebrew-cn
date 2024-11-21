class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https:melsman.github.iomlkit"
  url "https:github.commelsmanmlkitarchiverefstagsv4.7.13.tar.gz"
  sha256 "a6da888137ffa3d33850d579b95509ed926c20cd4ce5bc2450dcd6d3d3c6e4aa"
  license "GPL-2.0-or-later"
  head "https:github.commelsmanmlkit.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 sonoma:       "91b9c4a31cc76d0e578d500bdb1aa5ebf49b1fbd955553b73aaf810a33991e34"
    sha256 ventura:      "4db71f1fbe0aa6d57e00086a6c97da0f083c5707462c37ed4ca065e80099e730"
    sha256 x86_64_linux: "f25984b3a27fcd5154df63de09b904bd4271a3302e0f22f264f45ce52ba2a153"
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
    system bin"mlkit", "-o", "test", "test.sml"
    assert_equal "Result: OK\n", shell_output(".test")
  end
end