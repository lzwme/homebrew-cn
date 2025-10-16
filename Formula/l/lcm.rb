class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://ghfast.top/https://github.com/lcm-proj/lcm/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "40ba0b7fb7c9ad06d05e06b4787d743cf11be30eb4f1a03abf4a92641c5b1203"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcm-proj/lcm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "38eded00423ba9f45368e5634d3d8937e244805400a725d751726bf87c4d3a3b"
    sha256 cellar: :any,                 arm64_sequoia: "4e80a12ec4fd01f0b46db53073248672de8d5afe6461061fc0a322be967bef6f"
    sha256 cellar: :any,                 arm64_sonoma:  "4bb2ead4981d9372f79102cb2af715174ff2bf070e0aeb719d82ab187fea7048"
    sha256 cellar: :any,                 sonoma:        "5184db7cf28d7980361b3a069d642daa1d19baab99e0af938a99c4c1717a649a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e79ec267e99c4f2d9a1049ff9bbb493838577d407ba8db500afcd6ab56c3210b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab6d175fb759a02def0954cc93c8124f67ce38e354311b1ec459f82b9144d6fe"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.14"

  def python3
    which("python3.14")
  end

  def install
    # Adding RPATH in #{lib}/lua/X.Y/lcm.so and some #{bin}/*.
    lua_lib = lib/"lua"/Formula["lua"].version.major_minor
    lcm_site_packages = prefix/Language::Python.site_packages("python3")/"lcm"
    rpaths = [rpath, rpath(source: lua_lib), rpath(source: lcm_site_packages)]

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DLCM_ENABLE_EXAMPLES=OFF
      -DLCM_ENABLE_TESTS=OFF
      -DLCM_JAVA_TARGET_VERSION=8
      -DPYTHON_EXECUTABLE=#{python3}
    ]

    # `lcm-lua/lualcm_lcm.c:577:9: error: ‘subscription’ may be used uninitialized`
    # See discussions in https://github.com/lcm-proj/lcm/issues/457
    ENV.append_to_cflags "-Wno-maybe-uninitialized" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"example_t.lcm").write <<~EOS
      package exlcm;
      struct example_t {
          int64_t timestamp;
          double position[3];
          string name;
      }
    EOS
    system bin/"lcm-gen", "-c", "example_t.lcm"
    assert_path_exists testpath/"exlcm_example_t.h", "lcm-gen did not generate C header file"
    assert_path_exists testpath/"exlcm_example_t.c", "lcm-gen did not generate C source file"
    system bin/"lcm-gen", "-x", "example_t.lcm"
    assert_path_exists testpath/"exlcm/example_t.hpp", "lcm-gen did not generate C++ header file"
    system bin/"lcm-gen", "-j", "example_t.lcm"
    assert_path_exists testpath/"exlcm/example_t.java", "lcm-gen did not generate Java source file"
    system bin/"lcm-gen", "-p", "example_t.lcm"
    assert_path_exists testpath/"exlcm/example_t.py", "lcm-gen did not generate Python source file"
  end
end