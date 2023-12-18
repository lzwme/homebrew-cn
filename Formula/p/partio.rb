class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https:github.comwdaspartio"
  url "https:github.comwdaspartioarchiverefstagsv1.17.1.tar.gz"
  sha256 "5d00fbfc55817acb310bcaf61212a78b2c602e08b839060dfee69570b4b82464"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4190275eaab2237478ec8ed6a67f1a4d80df2054a33fa2a16eeeef2a2df97093"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74bda8a42983f06954ecd4d2e1dca980e53e26735759591a29d9ea3cf65f8326"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c397d2f8e5950eb8efa481f8712435db116b985eab3ac80008d193aae1f17f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "404a097330457846beb3ffcba2ee486821c8d209f6b78b21d2f7fc21d8bc8a32"
    sha256 cellar: :any_skip_relocation, ventura:        "6a3e5cc7e0209696bedd6d51206b9bf94d714de01dd62c666fcb8942cc7878ef"
    sha256 cellar: :any_skip_relocation, monterey:       "1ac550d4e1becb13ff7361704878b733c5508fad437a3fdf7615260f98844577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbbdeafe9f2d3a0e99381f928c3e70b54244430e9eae60060c4fb4def6e50fa4"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@3.12"

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    args = std_cmake_args
    args << "-DPARTIO_USE_GLVND=OFF" unless OS.mac?

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "doc"
      system "make", "install"
    end
    pkgshare.install "srcdata"
  end

  test do
    assert_match "Number of particles:  25", shell_output("#{bin}partinfo #{pkgshare}datascatter.bgeo")
  end
end