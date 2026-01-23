class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://ghfast.top/https://github.com/pachterlab/kallisto/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "a8bcc23bca6ac758f15e30bb77e9e169e628beff2da3be2e34a53e1d42253516"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "15c815ef2a93f3146564787c2c161bb20cdf757e0f62b5fdaf339adc5c282a44"
    sha256 cellar: :any,                 arm64_sequoia: "ceab1faa800ab8b8b82a197142dc5f3520897089cbfb97eddf080bf3178085d0"
    sha256 cellar: :any,                 arm64_sonoma:  "ba1270ba9840d1547752cd56bd71678a08dfb4dec5e1564aae71ca43c2858eaf"
    sha256 cellar: :any,                 sonoma:        "d0a212cf0c56d348b3665b7338957e457890501cf58c8f20f2cd250d790330dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40005484f9991f8c84a914e970f83424f5917abe9d4501c02951fb22e5b2b690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "092a025475cfbabeef5f0ccb3b8e65faf367bc35779f845f8c01ce598a90c70a"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  uses_from_macos "zlib"

  # Fix compilation error in Bifrost
  # https://github.com/pachterlab/kallisto/issues/488
  patch do
    url "https://github.com/pmelsted/bifrost/commit/d228b532a2cd5d3a598092ea4c46d1e997e50737.patch?full_index=1"
    sha256 "75ae03575fc1ab9826504ec297d2b424fe779dae6e9edebdeaf78a8a8b4e55cd"
    directory "ext/bifrost"
  end

  def install
    # Fix to error: unsupported option '-mno-avx2'
    inreplace "ext/bifrost/CMakeLists.txt", "-mno-avx2", ""

    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    ENV.deparallelize

    # Workaround to build with CMake 4
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    system "cmake", "-S", ".", "-B", "build", "-DUSE_HDF5=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >seq0
      FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVCLVYRTDQAQDVKKIEKF
    EOS

    output = shell_output("#{bin}/kallisto index -i test.index test.fasta 2>&1")
    assert_match "has 1 contigs and contains 32 k-mers", output
  end
end