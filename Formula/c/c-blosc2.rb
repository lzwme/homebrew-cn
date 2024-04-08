class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https:www.blosc.org"
  url "https:github.comBloscc-blosc2archiverefstagsv2.14.3.tar.gz"
  sha256 "2b94c2014ba455e8136e16bf0738ec64c246fcc1a77122d824257caf64aaf441"
  license "BSD-3-Clause"
  head "https:github.comBloscc-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6560069fa787dfaa4bbf77b10120f743429f487cc5e6a3e7ff5adb26eaf9f52a"
    sha256 cellar: :any,                 arm64_ventura:  "4015b276c5881a8472ac83da157a9f1f0199b3e10b0d62ec235c0218a00abfd5"
    sha256 cellar: :any,                 arm64_monterey: "293c0baacc72799b3b57bc0d043af8e2fdf70f648e876ce370ef9d274298b5a4"
    sha256 cellar: :any,                 sonoma:         "a4f503034acf80a56acccb5c5904440cc77af3c8452318e03b0505c706404347"
    sha256 cellar: :any,                 ventura:        "fed9d1684de4e303268130df6884137ad4568e6a1d3c6570d21c98bf884ab57b"
    sha256 cellar: :any,                 monterey:       "775cb3a631fd37e9623d0025dd8c0f4dee46b6c584eaf1ec9e6d7bdd1797c105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c77295644ac4a5aa4dd323da48ece20dca526a623417fce4c7598b34b79a1960"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    args = %w[
      -DPREFER_EXTERNAL_LZ4=ON
      -DPREFER_EXTERNAL_ZLIB=ON
      -DPREFER_EXTERNAL_ZSTD=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examplessimple.c"
  end

  test do
    system ENV.cc, pkgshare"simple.c", "-I#{include}", "-L#{lib}", "-lblosc2", "-o", "test"
    assert_match "Successful roundtrip!", shell_output(testpath"test")
  end
end