class Tlx < Formula
  desc "Collection of Sophisticated C++ Data Structures, Algorithms and Helpers"
  homepage "https://tlx.github.io"
  url "https://ghproxy.com/https://github.com/tlx/tlx/archive/v0.6.1.tar.gz"
  sha256 "24dd1acf36dd43b8e0414420e3f9adc2e6bb0e75047e872a06167961aedad769"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5bf4de79e505634d807afd511f8c30b43e1f770a0d727549f8428fa504308f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d67f614d8877c5fc1796c9e7c4d913fe085890e2556908fb7d0ee767c7bbdd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14ad8d90c73c62b2e9b1332ed5ffbe59487cfbcf36d0157390fd9e59327ec6c5"
    sha256 cellar: :any_skip_relocation, ventura:        "1fa9c67739a557c7faba1bf0a20352d8ecef8e79f32ba8caf2ef293fdc098dcd"
    sha256 cellar: :any_skip_relocation, monterey:       "0065add2f25b25eeb527aeb48625e34563d0afb702a496c67223ee78f3570547"
    sha256 cellar: :any_skip_relocation, big_sur:        "00ee92b029c92c9ac1f8326e9b039970097b802fe6ab79c2b8cf33251e3e7f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67f35bf407415cf0ab4f5afba211439f82b8da3495a6a52b0301c3a76f099b8"
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