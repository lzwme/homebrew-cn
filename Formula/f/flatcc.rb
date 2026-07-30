class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://ghfast.top/https://github.com/dvidelabs/flatcc/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "29db48a025bda2dd79399fc36f1d26516343414c0cf7d0b751b8add6b2e6181b"
  license "Apache-2.0"
  head "https://github.com/dvidelabs/flatcc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ca4b282b361e7e83dfc88b5ee171ad03108e6e56bd29ca56609790bce3d1b64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaa7ad0bef136311b272ae6905a750553359e699941cc7e3a7b87b992161b7bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0544b7c9c23d84c61e03b999f20f54d09706b0a9a8bbf53a504b1ae28398e03"
    sha256 cellar: :any_skip_relocation, sonoma:        "8039d11f24f3e5afa9033e69970fa0e79d6a9752a586a0fc9cb2c1635410daf3"
    sha256 cellar: :any,                 arm64_linux:   "765763665c7b8dfc11e858300026d66560aa503bd8b52989ed838c73d67c5637"
    sha256 cellar: :any,                 x86_64_linux:  "cfa63cbb106d0c0d0498414dd1470a4d375cfaacf09f5021d94ba662572240ed"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DFLATCC_INSTALL=ON
      -DFLATCC_INSTALL_LIB=#{lib}
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.fbs").write <<~EOS
      // example IDL file

      namespace MyGame.Sample;

      enum Color:byte { Red = 0, Green, Blue = 2 }

      union Any { Monster }  // add more elements..

        struct Vec3 {
          x:float;
          y:float;
          z:float;
        }

        table Monster {
          pos:Vec3;
          mana:short = 150;
          hp:short = 100;
          name:string;
          friendly:bool = false (deprecated);
          inventory:[ubyte];
          color:Color = Blue;
        }

      root_type Monster;

    EOS

    system bin/"flatcc", "-av", "--json", "test.fbs"
  end
end