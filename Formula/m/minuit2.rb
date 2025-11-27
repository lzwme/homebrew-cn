class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.36.06.source.tar.gz"
  sha256 "62f9d38d2f2ed3d46653529c98e8cbc9b8866776494eb40ba0c23e2f46b681c4"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b78d35d21e2dd77b4c0540c57188ad0db1f9bc54e81a6e3b84df78b477a27c08"
    sha256 cellar: :any,                 arm64_sequoia: "f0485d00ad234409c5216cb4d1a18c741770a747f4e2157d8eb6b63c1cff4644"
    sha256 cellar: :any,                 arm64_sonoma:  "4a5242e5a4140ee10aea4de55330cd87c660864b431e1871239b39c9f1d1c1a7"
    sha256 cellar: :any,                 sonoma:        "3ed7505c5854b5614be172ecf02fdc1c4d51f09fc9ff68c4859c8da2ff410aff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18dc6b68c33a4b558307cbbc6541266a81baf70040aae650f3f119864767998d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "249febea10055e0bc514b7152f15f64f9705baace3a4a4c312582577a6b1fcdf"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "math/minuit2", "-B", "build/shared", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "math/minuit2", "-B", "build/static", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/libMinuit2*.a"]

    pkgshare.install "math/minuit2/test/MnTutorial"
  end

  test do
    cp Dir[pkgshare/"MnTutorial/{Quad1FMain.cxx,Quad1F.h}"], testpath
    system ENV.cxx, "-std=c++14", "Quad1FMain.cxx", "-o", "test", "-I#{include}/Minuit2", "-L#{lib}", "-lMinuit2"
    assert_match "par0: -8.26907e-11 -1 1", shell_output("./test")
  end
end