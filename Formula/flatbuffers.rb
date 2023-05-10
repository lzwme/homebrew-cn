class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://ghproxy.com/https://github.com/google/flatbuffers/archive/v23.5.8.tar.gz"
  sha256 "55b75dfa5b6f6173e4abf9c35284a10482ba65db886b39db511eba6c244f1e88"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5b6da875d47aeacd8f2e22eb6ca140e75c925f5880c226a85510060bdba63a5b"
    sha256 cellar: :any,                 arm64_monterey: "b4f5f42b306a6c64f3447b9b844da7eef007b3404db5f1950f3021a66d41561c"
    sha256 cellar: :any,                 arm64_big_sur:  "16000644a8c97128f822ba175cd2d27a5497bc8008b6a30665f1cdecb4e170ca"
    sha256 cellar: :any,                 ventura:        "1ca414db90249682cf412d552bf0956a6d79ca429e26e5696bd50090525396c4"
    sha256 cellar: :any,                 monterey:       "9c6123db88b04bc48d821e2360794045732ca9c631f8ebc41504043a4d5f6c81"
    sha256 cellar: :any,                 big_sur:        "18f62c537d83eab89308868e5cb6a4ac89158076880e1ee0ac1f733daf792177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21b89720373955796575b3f62ee934e6c2615b30dd274ca3783153406cde2f10"
  end

  depends_on "cmake" => :build

  conflicts_with "osrm-backend", because: "both install flatbuffers headers"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DFLATBUFFERS_BUILD_SHAREDLIB=ON",
                    "-DFLATBUFFERS_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testfbs = <<~EOS
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
    (testpath/"test.fbs").write(testfbs)

    testjson = <<~EOS
      {
        pos: {
          x: 1,
          y: 2,
          z: 3
        },
        hp: 80,
        name: "MyMonster"
      }
    EOS
    (testpath/"test.json").write(testjson)

    system bin/"flatc", "-c", "-b", "test.fbs", "test.json"
  end
end