class Modflow6 < Formula
  desc "USGS modular hydrologic model"
  homepage "https://www.usgs.gov/software/modflow-6-usgs-modular-hydrologic-model"
  url "https://ghfast.top/https://github.com/MODFLOW-ORG/modflow6/archive/refs/tags/6.8.1.tar.gz"
  sha256 "16b9368d582c66de83106a4c075d22c2a7a08daa7d8dfb7f40e21a5d983be699"
  license "CC0-1.0"
  head "https://github.com/MODFLOW-ORG/modflow6.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ac891bef98937e8a2542a9793e20a6e3bdc1d9e9145fa804fef50cd21d4485f3"
    sha256 cellar: :any, arm64_tahoe:       "128a08d785a3bae0398a4473773cb3776c877c14a330e673752646e6aa6c2fa3"
    sha256 cellar: :any, arm64_sequoia:     "fee54d749c2c38f235939481c6388f68529d7ed8c4ab72e2573f54f35b013c2f"
    sha256 cellar: :any, arm64_linux:       "92674173e5aa71b6222ac2ecead01bc3648989d090a2a8b8756d843dff152ba0"
    sha256 cellar: :any, x86_64_linux:      "b2b2951e634bd5ac4d2b1d107bd0458bdccf014846a08e8e66ae2ae29cf960c1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gcc" # for gfortran

  deny_network_access!

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install ".mf6minsim" => "mf6minsim"

    # zbud6 is a utility built by the default meson targets and is not packaged
    rm bin/"zbud6"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mf6 --version")

    cp_r pkgshare/"mf6minsim/.", testpath
    system bin/"mf6"
    assert_match "Normal termination of simulation", (testpath/"mfsim.lst").read

    # run the same one-step simulation through libmf6
    rm testpath/"mfsim.lst"
    (testpath/"test.c").write <<~C
      int initialize(void), update(void), finalize(void);
      int main(void) { return initialize() || update() || finalize(); }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lmf6", "-Wl,-rpath,#{lib}", "-o", "test"
    system "./test"
    assert_match "Normal termination of simulation", (testpath/"mfsim.lst").read
  end
end