class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https:www.blosc.org"
  url "https:github.comBloscc-blosc2archiverefstagsv2.16.0.tar.gz"
  sha256 "9c2d4a92b43414239120cedf757cbdfbe1e5d9ba21c8779396c553fc0c883f3a"
  license "BSD-3-Clause"
  head "https:github.comBloscc-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5bf2771df920dd70388d5425663d557f44094acd499dd4252e4bee5f1be225ac"
    sha256 cellar: :any,                 arm64_sonoma:  "583b4af01cc5c4ca9b11d7e773c6917b7c7408916601da1e0bdeed91d5538494"
    sha256 cellar: :any,                 arm64_ventura: "5783e022aec98664d5739374c51c4f5ad19c6f980182d7cc060396b5541e4ec1"
    sha256 cellar: :any,                 sonoma:        "8094ba7ac79c4d159ac7c65ae907c21e675e02c8d6150c7b0deafe5f84d062f8"
    sha256 cellar: :any,                 ventura:       "76acd6f4c6a352302ed31bfa708653a28218c241253322e59bd173dc33516544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5b7dc4fc8845a7e127372bcf62420a33a18f65c7294e2dd6760739e2dc39411"
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