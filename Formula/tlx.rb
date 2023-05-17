class Tlx < Formula
  desc "Collection of Sophisticated C++ Data Structures, Algorithms and Helpers"
  homepage "https://tlx.github.io"
  url "https://ghproxy.com/https://github.com/tlx/tlx/archive/v0.5.20230516.tar.gz"
  sha256 "528f08411174a0a98bf7c5c3b47cb383037904a59c5152554c3fcbf4df779871"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a69532658e43498520f22a3edb9a3042c9698e42d10b7f6cd18605207ac623b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "045ff89aaaba445098d2107dc167ddff844528f52ef8b37c16bc4d5f9f61a785"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b62cf60de877378226f6ca08c70a365c727b12d06670c188b5043a0a3ec2200"
    sha256 cellar: :any_skip_relocation, ventura:        "750c04c27a2501a7dd8327ece132df14f159737e38abe6ccf98e6b4b157a9e8d"
    sha256 cellar: :any_skip_relocation, monterey:       "fcfa9aa83f6e98d4192679aac5dd517e781c5ce37f33d30c7bee3ee6458f2770"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9c3fd00dc1e6845a156592f4d0385cb0effab1606871c9cf89828fb95015750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd7bcbe8dba3c739b80a4d866a4ca9ddf3b02d726bcdf1fb20a42bba246a79ae"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + [".."]
    mkdir "build" do
      system "cmake", ".", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tlx/math/aggregate.hpp>
      int main()
      {
        tlx::Aggregate<int> agg;
        for (int i = 0; i < 30; ++i) {
          agg.add(i);
        }
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltlx", "-o", "test", "-std=c++17"
    system "./test"
  end
end