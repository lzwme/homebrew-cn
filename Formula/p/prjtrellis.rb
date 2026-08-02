class Prjtrellis < Formula
  desc "Documenting the Lattice ECP5 bit-stream format"
  homepage "https://github.com/YosysHQ/prjtrellis"
  url "https://ghfast.top/https://github.com/YosysHQ/prjtrellis/archive/refs/tags/1.4.tar.gz"
  sha256 "46fe9d98676953e0cccf1d6332755d217a0861e420f1a12dabfda74d81ccc147"
  license all_of: ["ISC", "MIT"]
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36912b5c1a3ef5ce08ab7debc15ab3a008b08414a278ea427e2aaac4c680f7f0"
    sha256 cellar: :any,                 arm64_sequoia: "946ddd11b4243cb585ca98ca0ab7bd5761d8902c520f2e6e3d5627db9a7a0579"
    sha256 cellar: :any,                 arm64_sonoma:  "4991ec64518c08ee6a0dfa8e96c4c8f6d7639c7833fe1d3cf36534da23746ba2"
    sha256 cellar: :any,                 sonoma:        "6d6c1a930acb39324a74a5b2b8fdc95a7ff0557121051e57b1e83b0206fe32f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94308fe20b1a9d6924cd1a3576b1f1b1eddc39e2ea6844a2575b07c1b6606482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f2fc246b54917d76e6dd898ab68b56fa8311482ad8db4f817cdae537cd81a1"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "python@3.14"

  resource "prjtrellis-db" do
    url "https://ghfast.top/https://github.com/YosysHQ/prjtrellis/releases/download/1.4/prjtrellis-db-1.4.zip"
    sha256 "4f8a8a5344f85c628fb3ba3862476058c80bcb8ffb3604c5cca84fede11ff9f0"

    livecheck do
      formula :parent
    end
  end

  # Fix build with Boost 1.89.0
  patch do
    url "https://github.com/YosysHQ/prjtrellis/commit/e821bcbecdc997d71766836a200e16b27535a835.patch?full_index=1"
    sha256 "22a47fb89f4ed1b501823be12b5ea18bf03cae5f8749cd63fbe6972d8e69d764"
    type :backport
    resolves "https://github.com/YosysHQ/prjtrellis/issues/251"
  end

  def install
    (buildpath/"database").install resource("prjtrellis-db")

    system "cmake", "-S", "libtrellis", "-B", "libtrellis",
                    "-DCURRENT_GIT_VERSION=#{version}", *std_cmake_args
    system "cmake", "--build", "libtrellis"
    system "cmake", "--install", "libtrellis"
  end

  test do
    resource "homeebrew-ecp-config" do
      url "https://www.trabucayre.com/blink.config"
      sha256 "394d71ba416517cceee5135b853dd1e94f99b07d5e9a809760618fa820d32619"
    end

    testpath.install resource("homeebrew-ecp-config")

    system bin/"ecppack", testpath/"blink.config", testpath/"blink.bit"
    assert_path_exists testpath/"blink.bit"

    system bin/"ecpunpack", testpath/"blink.bit", testpath/"foo.config"
    assert_path_exists testpath/"foo.config"

    system bin/"ecppll", "-i", "12", "-o", "24", "-f", "pll.v"
    assert_path_exists testpath/"pll.v"

    system bin/"ecpbram", "-g", "ram.hex", "-w", "16", "-d", "512"
    assert_path_exists testpath/"ram.hex"
  end
end