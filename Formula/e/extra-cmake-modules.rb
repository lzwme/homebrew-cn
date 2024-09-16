class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.6/extra-cmake-modules-6.6.0.tar.xz"
  sha256 "206e23e05ba8934ac7a275c8fdd3704165f558878d3dbe3299f991473997ccb8"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42961b34dad3b6b7ebbf3eb0b3619e5487800b3435c3208661bf9fbf300d9cf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42961b34dad3b6b7ebbf3eb0b3619e5487800b3435c3208661bf9fbf300d9cf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42961b34dad3b6b7ebbf3eb0b3619e5487800b3435c3208661bf9fbf300d9cf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cefb9795390363bc8cdc6f8c930de5a451efbe0eb658138f19be3d35d3318d6a"
    sha256 cellar: :any_skip_relocation, ventura:       "cefb9795390363bc8cdc6f8c930de5a451efbe0eb658138f19be3d35d3318d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42961b34dad3b6b7ebbf3eb0b3619e5487800b3435c3208661bf9fbf300d9cf7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test)
      find_package(ECM REQUIRED)
    EOS
    system "cmake", "."

    expected = "ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, (testpath/"CMakeCache.txt").read
  end
end