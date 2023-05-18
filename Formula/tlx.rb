class Tlx < Formula
  desc "Collection of Sophisticated C++ Data Structures, Algorithms and Helpers"
  homepage "https://tlx.github.io"
  url "https://ghproxy.com/https://github.com/tlx/tlx/archive/v0.6.0.tar.gz"
  sha256 "273fec7d7d184f6836f2a043e79144a09b8424989d37c7bad7383070154c6509"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6d27c8864a5bd1fd5237b2cb0bd7f676913773fc817fedc951f437649988800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "393caa8be67be807697c182e79c630b6b5d86fa4dd5aff2a29e8099f3aa1eefa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "677430a5fbc565403459f36535112aa72448a853c339436dde3d815a1ef747f3"
    sha256 cellar: :any_skip_relocation, ventura:        "7fd593870ebc5a83373f685a07a05ad6a56141b8ceacf6b96e25d8bfd489c5d3"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ae18b1b73a421ad4e4aa6770757ba87efcbd156ed6cf50e0a6e3c558d412b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "106333715fb6307902a75ef30a13f9f08962507e0eb62a203f10a36ac3fadcde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d670608e9556afeceb31188f54decc6e4c9d9cd47e8c7bcf418aecb91e935f9e"
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