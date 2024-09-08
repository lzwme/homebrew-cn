class Jinx < Formula
  desc "Embeddable scripting language for real-time applications"
  homepage "https:github.comJamesBoerJinx"
  url "https:github.comJamesBoerJinxarchiverefstagsv1.3.10.tar.gz"
  sha256 "5b3a3e6c2c4b976dfdb16519aee7299c98dbf417b8179099a5509a5fd4d513ac"
  license "MIT"
  head "https:github.comJamesBoerJinx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24313e091b9222029e7d5e6e4aea87ef70e20facef9a6b82e0a0d4abfffcc511"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76c5986afd50a5bbe9ee092ab25dfe8633ae63e1895b5ee90107f508a6297673"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "362834274bbb963b081203c47ece5ccbae44ab6959177d293f2d6af86b2063bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cc147cfcb7b0769a0570f011806266e8762eea26cc751fc49df4749f5e73de8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3353d9402dd94c01eaaa937bcb58590824f144027f54fadacdaa4584b6f03979"
    sha256 cellar: :any_skip_relocation, ventura:        "6f9d56b84c16029fbec98ffe69d6fcf84e83effbeabde98cd2c3a553cbb366ff"
    sha256 cellar: :any_skip_relocation, monterey:       "cafc3ac794c99f4e0a74380927681bd35eb465eb22d940a99cee23aae2f8ea61"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb75b3db57ce5a1349190419c5e1f7e880c74c0d0f8ae5485a708739358592ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca7c15cf146241f441cf37fd695dbae391da90bdb5cf6b3fcf7d3c1f05be2270"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    # disable building tests
    inreplace "CMakeLists.txt", "if(NOT jinx_is_subproject)", "if(FALSE)"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    lib.install "buildlibJinx.a"

    include.install Dir["Source*.h"]
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include "Jinx.h"

      int main() {
         Create the Jinx runtime object
        auto runtime = Jinx::CreateRuntime();

         Text containing our Jinx script
        const char * scriptText =
        u8R"(

        -- Use the core library
        import core

        -- Write to the debug output
        write line "Hello, world!"

        )";

         Create and execute a script object
        auto script = runtime->ExecuteScript(scriptText);
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lJinx", "-o", "test"
    assert_match "Hello, world!", shell_output(".test")
  end
end