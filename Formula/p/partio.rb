class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://ghfast.top/https://github.com/wdas/partio/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "128913266a88a0939aaa4bc951ae4d4da1c380408bcc0ea9e7f526556afeaad0"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05ebbd168cfa1a7478360070bef9bf428fcf2fc309570d036fe23748807169b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94dc712e12895507397e6db831b4b7bcfb39e3d62cc575b0f5aceb231ee17796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bcd1744a265d8f5e77467a4bb70ff7c832962dc64c9baca36be891409c1d4b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6551a6ba9cc3babbb51af05b90920dd47a0510ce2dde16adf2fb748b61f6dc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acd09d35e612f33f8b3eca6afeeba1d53bdef467250eaf0397a6a5cd7bd83752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc119d3bc73b357384ab579d1f24f61a2423241ee49ce4c0e50f3a29a98813f"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@3.14"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    args = std_cmake_args
    args << "-DPARTIO_USE_GLVND=OFF" unless OS.mac?

    system "cmake", "-S", ".", "-B", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--build", ".", "--target", "doc"
    system "cmake", "--install", "."

    pkgshare.install "src/data"
  end

  test do
    assert_match "Number of particles:  25", shell_output("#{bin}/partinfo #{pkgshare}/data/scatter.bgeo")
  end
end