class Cmrc < Formula
  desc "CMake Resource Compiler"
  homepage "https:github.comvector-of-boolcmrc"
  url "https:github.comvector-of-boolcmrcarchiverefstags2.0.1.tar.gz"
  sha256 "edad5faaa0bea1df124b5e8cb00bf0adbd2faeccecd3b5c146796cbcb8b5b71b"
  license "MIT"
  head "https:github.comvector-of-boolcmrc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83995bde44389b6ca36674aee504fa109bfc893102e95bfbf03d7c20a09347b8"
  end

  depends_on "cmake" => [:build, :test]

  def install
    (share"cmake").install "CMakeRC.cmake"
  end

  def caveats
    <<~EOS
      To use CMakeRC, add
        #{opt_share}cmake
      to your `CMAKE_MODULE_PATH`.
    EOS
  end

  test do
    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.30)
      include(CMakeRC)
    CMAKE
    system "cmake", ".", "-DCMAKE_MODULE_PATH=#{share}cmake", *std_cmake_args
  end
end