class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://ghfast.top/https://github.com/google/draco/archive/refs/tags/1.5.8.tar.gz"
  sha256 "d42d730526c8dd0ed2ac0b3edc6495bda4bc78298031ad5cb4dc94a8bdd93f94"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "75458f215bf72aa807ac07049cd76cb666c9d2581fa7b48b27a9ca49217de918"
    sha256 cellar: :any, arm64_tahoe:       "73463c7496e38b2d644e86a63867210a499214f4503b1d10a60ff75cdde34280"
    sha256 cellar: :any, arm64_sequoia:     "a4888d9b21db5246d6c5f463a76fc25c69d277bb9d33c5eae9840cec2076d2b7"
    sha256 cellar: :any, arm64_linux:       "8bdf152932b6cd59843b70ff79303f6133d61c9eb23e545d629e16623635a0a5"
    sha256 cellar: :any, x86_64_linux:      "a5d58d6d8fbb89d69c7f48778c313f6bee19e8b02ff47bb40bfcdc108cde3c6c"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "testdata/cube_att.ply"
  end

  test do
    cp pkgshare/"cube_att.ply", testpath

    output = shell_output("#{bin}/draco_encoder -i cube_att.ply -o cube_att.drc")
    assert_path_exists testpath/"cube_att.drc"
    assert_match <<~EOS, output
      Encoder options:
        Compression level = 7
        Positions: Quantization = 11 bits
        Normals: Quantization = 8 bits
    EOS
  end
end