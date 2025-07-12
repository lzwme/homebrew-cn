class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://ghfast.top/https://github.com/m3g/packmol/archive/refs/tags/v21.0.3.tar.gz"
  sha256 "902e885e4b08ca728333b7cb56c9d8e46c4581f9f8d503ac42d13e24e00dc185"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b9e4ce1c6ba05110665f8542832753836916a5c08beefed30db3740d40b05d8d"
    sha256 cellar: :any,                 arm64_sonoma:  "ad0679072eee11caa681804144d4967568bb78ac94b919eb13c0db46f2403d34"
    sha256 cellar: :any,                 arm64_ventura: "e26a7e3527f4990e9f4b729a26d9c4f04924c63ab8834ee687ff3d055f92f148"
    sha256 cellar: :any,                 sonoma:        "a066dfcc837fd6afe7e7840b462bc365c329d4ac1f6db65282f043ebdd926829"
    sha256 cellar: :any,                 ventura:       "577450e69d644f761785f10cb68ef75670f3aae0ada58ea9c57011ba2bab936e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "691afc5e0cbaf853e197cea3a55ee97c04d3442bec09252ba39ac6b718eacc36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05795238e5cf6a7b0692dcb455e7b5f857670be9574b2f364b8913489edce93c"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  resource "homebrew-testdata" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  # support cmake 4.0, upstream pr ref, https://github.com/m3g/packmol/pull/94
  patch do
    url "https://github.com/m3g/packmol/commit/a1da16a7f3aeb2e004a963cf92bf9e57e94e4982.patch?full_index=1"
    sha256 "5e073f744559a3b47c1b78075b445e3dd0b4e89e3918f4cbf8e651c77b83d173"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("homebrew-testdata")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end