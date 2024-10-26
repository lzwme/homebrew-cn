class Primesieve < Formula
  desc "Fast CC++ prime number generator"
  homepage "https:github.comkimwalischprimesieve"
  url "https:github.comkimwalischprimesievearchiverefstagsv12.5.tar.gz"
  sha256 "20b06975a909dd58b956445948f7460086d8b49f2bc58880eac56400dcc66d64"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a760b30ac3779213cd8798599ec2d889e31405a34ff94ec47ed9b28ded5d3246"
    sha256 cellar: :any,                 arm64_sonoma:  "848827d9dbe541bdf487753c2590295690dd430ab9172d5340e453979b452dcc"
    sha256 cellar: :any,                 arm64_ventura: "c1b28f8fef3a7258d04a9e5afd36267b02afbdfc240fd405ed44fe7286245e96"
    sha256 cellar: :any,                 sonoma:        "24d1c178ad26ce5570b3d57bee1240a33c7e6f9ffe1733bad7972baba6a76387"
    sha256 cellar: :any,                 ventura:       "5cb007a8433e4ea8359d3aa10c19c48c5ba2c35a2bf1bb690ef6a8e44e31be07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01cd70df767e35da8c19077f8372353cd190542e29ffe7e89fe1b4b5a2f0d608"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"primesieve", "100", "--count", "--print"
  end
end