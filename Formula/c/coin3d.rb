class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin) with Python bindings (Pivy)"
  homepage "https://coin3d.github.io/"
  license all_of: ["BSD-3-Clause", "ISC"]
  revision 4

  stable do
    url "https://ghproxy.com/https://github.com/coin3d/coin/archive/refs/tags/Coin-4.0.0.tar.gz"
    sha256 "b00d2a8e9d962397cf9bf0d9baa81bcecfbd16eef675a98c792f5cf49eb6e805"

    resource "pivy" do
      url "https://ghproxy.com/https://github.com/coin3d/pivy/archive/refs/tags/0.6.8.tar.gz"
      sha256 "c443dd7dd724b0bfa06427478b9d24d31e0c3b5138ac5741a2917a443b28f346"
    end
  end

  livecheck do
    url :stable
    regex(/^Coin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e3ee7994b4f8b781f9ef6368b7d6f4c8fd659e282eece950af537fa45b7dd630"
    sha256 cellar: :any, arm64_ventura:  "921271da7b44aba66b0ed13c986b849f167c87315206a5dc62dd662bb63afcd4"
    sha256 cellar: :any, arm64_monterey: "428735b5724d44c297805e06e664568b298fc47f169e268398706dc18af362c3"
    sha256 cellar: :any, arm64_big_sur:  "e0ffcfdf4603321f5331caf3f870586f819cb6a8a7c86bf88f621b5b3740ec6b"
    sha256 cellar: :any, sonoma:         "02b36aa9beb79630f1791d04eef1affb10c238edb3ce0cf6ec0c5bbb0e60e854"
    sha256 cellar: :any, ventura:        "575bbf4d248a7e1cd282ea6e4cb34a668515a26cff0cf653a1700a9bc91fe7f1"
    sha256 cellar: :any, monterey:       "22b2ebe3fea27b2c2636bc5e963834a5a4e29b2afb5d2a043f997e7fa5d89454"
    sha256 cellar: :any, big_sur:        "e823c1170d7caceff04fee98a5947a1333e1d67dc75cecf412811a8c01255275"
    sha256 cellar: :any, catalina:       "7cf7ce170be433841406d71f0feba6f0e69ace689986aaa0ce59453ba5294a26"
  end

  head do
    url "https://github.com/coin3d/coin.git", branch: "master"

    resource "pivy" do
      url "https://github.com/coin3d/pivy.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "pyside@2"
  depends_on "python@3.10"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def python3
    "python3.10"
  end

  def install
    # Create an empty directory for cpack to make the build system
    # happy. This is a workaround for a build issue on upstream that
    # was fixed by commit be8e3d57aeb5b4df6abb52c5fa88666d48e7d7a0 but
    # hasn't made it to a release yet.
    mkdir "cpack.d" do
      touch "CMakeLists.txt"
    end

    system "cmake", "-S", ".", "-B", "_build",
                    "-DCOIN_BUILD_MAC_FRAMEWORK=OFF",
                    "-DCOIN_BUILD_DOCUMENTATION=ON",
                    "-DCOIN_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    resource("pivy").stage do
      ENV.append_path "CMAKE_PREFIX_PATH", prefix.to_s
      ENV["LDFLAGS"] = "-Wl,-rpath,#{opt_lib}"
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Inventor/SoDB.h>
      int main() {
        SoDB::init();
        SoDB::cleanup();
        return 0;
      }
    EOS

    opengl_flags = if OS.mac?
      ["-Wl,-framework,OpenGL"]
    else
      ["-L#{Formula["mesa"].opt_lib}", "-lGL"]
    end

    system ENV.cc, "test.cpp", "-L#{lib}", "-lCoin", *opengl_flags, "-o", "test"
    system "./test"

    ENV.append_path "PYTHONPATH", Formula["pyside@2"].opt_prefix/Language::Python.site_packages(python3)
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    system python3, "-c", <<~EOS
      import shiboken2
      from pivy.sogui import SoGui
      assert SoGui.init("test") is not None
    EOS
  end
end