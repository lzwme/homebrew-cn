class Vvenc < Formula
  desc "Fraunhofer Versatile Video Encoder"
  homepage "https:github.comfraunhoferhhivvenc"
  url "https:github.comfraunhoferhhivvencarchiverefstagsv1.12.1.tar.gz"
  sha256 "ba353363779e8f835200f319c801b052a97d592ebc817b52c41bdce093fa2fe2"
  license "BSD-3-Clause-Clear"
  head "https:github.comfraunhoferhhivvenc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e905b360064285e30c7eb8c2713888cac93b28a9388b9bd5a84b0d50c3c2321a"
    sha256 cellar: :any,                 arm64_sonoma:  "ed236b0f8f357bc8273c8e213576d73177bebd535ad5b3eaa44307012baa9312"
    sha256 cellar: :any,                 arm64_ventura: "2917e29604a86fc73bc1f4286ca5587dc7f6dcbadea365d8a3b16b8af1d75ef3"
    sha256 cellar: :any,                 sonoma:        "145f0ed78517a567785ac249aca4dbdf0887a023fffab74c0704de89fd6cd59e"
    sha256 cellar: :any,                 ventura:       "ec19b435a3fc60d9dfa136cbe797cd23cd0ef91ea2e66869027424b96931ae61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9d458061236400c33382ea051b66ef09c596f8a52ef5639a87fa3b7ff1610f8"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DVVENC_INSTALL_FULLFEATURE_APP=1",
           "-DBUILD_SHARED_LIBS=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test_video" do
      url "https:raw.githubusercontent.comfraunhoferhhivvencmastertestdataRTn23_80x44p15_f15.yuv"
      sha256 "ecd2ef466dd2975f4facc889e0ca128a6bea6645df61493a96d8e7763b6f3ae9"
    end

    resource("homebrew-test_video").stage testpath
    system bin"vvencapp",
           "-i", testpath"RTn23_80x44p15_f15.yuv",
           "-s", "360x640",
           "--fps", "601",
           "--format", "yuv420_10",
           "--hdr", "hdr10_2020",
           "-o", testpath"RTn23_80x44p15_f15.vvc"
    assert_predicate testpath"RTn23_80x44p15_f15.vvc", :exist?
  end
end