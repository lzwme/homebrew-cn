class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.2/extra-cmake-modules-6.2.0.tar.xz"
  sha256 "6374bfa0dded8be265c702acd5de11eecd2851c625b93e1c87d8d0f5f1a8ebe1"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2d043ceffe6e2dbad9cf448aff5fd216def3cbe025e658fd021fbfb7147da8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da763898d3e34567ce36b32f4e4fe85fb0fd6779753f0e7b70ce9412940e8582"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "449c75125d243842be1ae34a26ec85ed0bffd9ac95f93883bb2db9f310e1ff89"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d54231ef31b2a7bdb6f3a555342dbc7a9e5b017e3fa4a8a899a4905b81506fd"
    sha256 cellar: :any_skip_relocation, ventura:        "63e7a70f681d24624fc419d9618cc1b48eedc509e1dadbeff0168609c74e658a"
    sha256 cellar: :any_skip_relocation, monterey:       "9c77f2ec8d729c20efa98702fbde0cf51a32e9a309c94281ec703bf88296420f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60f3ef8198822028292d8d1c8dbfd552c75629ef87fb9749b172b6c07ff4fb23"
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