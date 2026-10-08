class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://ghfast.top/https://github.com/melsman/mlkit/archive/refs/tags/v4.7.24.tar.gz"
  sha256 "519efe63a8362f7c9411adced5cfa6b9d251ed9cad1eb01c3f195f83452dc905"
  license "GPL-2.0-or-later"
  head "https://github.com/melsman/mlkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "7d84f1d6f038619900b82d26cb1bef57e6f886c845e48b70a7c08c5e4ea974c5"
    sha256 arm64_tahoe:       "3f1383d138eab3738a01932697ef4207b4e1fe3f2abc5d86c111df271617800d"
    sha256 arm64_sequoia:     "68203e7dd1c54d0dc0d7dcf0c15a771f06ed0f620d6af987985f602ff23e7cfb"
    sha256 x86_64_linux:      "ea3c1367113fef99f9228f7be0175fe0790079522279a4bccfc49ef29893309b"
  end

  depends_on "autoconf" => :build
  depends_on "gmp"

  on_linux do
    depends_on arch: :x86_64 # https://github.com/melsman/mlkit/tree/master#mlkit---native-backends
  end

  on_intel do
    depends_on "mlton" => :build
  end

  # Apple Silicon build requires building with mlkit not mlton.
  # Similar to other bootstraps, can keep on oldest compatible version.
  resource "bootstrap" do
    on_arm do
      url "https://ghfast.top/https://github.com/melsman/mlkit/releases/download/v4.7.24/mlkit-bin-dist-darwin.tgz"
      sha256 "3d01153394d967b2fead9fa004332f087066fba3904677b15423ac06e592739b"
    end
  end

  deny_network_access!

  def install
    # https://github.com/melsman/mlkit/tree/master#native-arm64-on-macos
    if OS.mac? && Hardware::CPU.arm?
      resource("bootstrap").stage("bootstrap")
      ENV["MLKIT_BOOTSTRAP"] = buildpath/"bootstrap/bin/mlkit"
      ENV["MLKIT_BOOTSTRAP_SML_LIB"] = buildpath/"bootstrap/lib/mlkit"
      ENV["MLKIT_BOOTSTRAP_FLAGS"] = "-gc"
      ENV["SML_LIB"] = buildpath
      ENV["DARWIN_NATIVE"] = "1"
      args = ["--with-compiler=mlkit"]
    end

    system "sh", "./autobuild"
    system "./configure", "--prefix=#{prefix}", *args

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
    (testpath/"test.sml").write <<~SML
      fun f(x) = x + 2
      val a = [1,2,3,10]
      val b = List.foldl (op +) 0 (List.map f a)
      val res = if b = 24 then "OK" else "ERR"
      val () = print ("Result: " ^ res ^ "\\n")
    SML
    system bin/"mlkit", "-o", "test", "test.sml"
    assert_equal "Result: OK\n", shell_output("./test")
  end
end