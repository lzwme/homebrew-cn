class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://ghfast.top/https://github.com/melsman/mlkit/archive/refs/tags/v4.7.23.tar.gz"
  sha256 "6a79ae8d910392827d3405c2acb3bd975f568c76d0da5db0bf5017077de1fb1f"
  license "GPL-2.0-or-later"
  head "https://github.com/melsman/mlkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "e24b7427a34ac06de335882227851b72ed9a3df7b37d9637862314fc83d3ebfd"
    sha256 arm64_tahoe:       "f8d5a3680ede372d063795b2da20293cb1713b9a3ed5385ab56ed77a6522c513"
    sha256 arm64_sequoia:     "a76c1f1fb63cda699f7c31440ae3ceb478603e7cc9d46b3839282dc3348a4186"
    sha256 x86_64_linux:      "c0aae9571a07a319cdd9e4e6bef46ff6b26adb63a59fa7633c33a8901460e5bd"
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
      url "https://ghfast.top/https://github.com/melsman/mlkit/releases/download/v4.7.23/mlkit-bin-dist-darwin.tgz"
      sha256 "1872feca49574c2dacc1e508657c6bdec3fdcd38a2fb71b9ab929c1c8735229b"
    end
  end

  deny_network_access!

  def install
    # https://github.com/melsman/mlkit/tree/master#native-arm64-on-macos
    if OS.mac? && Hardware::CPU.arm?
      resource("bootstrap").stage("bootstrap")
      ENV["MLKIT_BOOTSTRAP"] = buildpath/"bootstrap/bin/mlkit"
      ENV["MLKIT_BOOTSTRAP_SML_LIB"] = buildpath/"bootstrap"
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