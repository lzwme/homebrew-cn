class Marisa < Formula
  desc "Matching Algorithm with Recursively Implemented StorAge"
  homepage "https:github.coms-yatamarisa-trie"
  url "https:github.coms-yatamarisa-triearchiverefstagsv0.2.7.tar.gz"
  sha256 "d4e0097d3a78e2799dfc55c73420d1a43797a2986a4105facfe9a33f4b0ba3c2"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0bedacd84d336fe4bb03ba64d12c4b9558342bdc885ed1a730cc6c085cdac419"
    sha256 cellar: :any,                 arm64_sonoma:  "795ef8dde700a58b25068458ee84b339203647fdf847f65d9ec315f319569099"
    sha256 cellar: :any,                 arm64_ventura: "a2411485b60b2f253d201eb1499a94561a79d027742063e90e610d9ad0aa24b9"
    sha256 cellar: :any,                 sonoma:        "7b2008113fb52501f543358aa694c0050fba22e722d4fe2283d8515f39046025"
    sha256 cellar: :any,                 ventura:       "ae6b75381f71824e572676ee4a85f8164b306a08d8280ce729d21f36a2711f89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7ead9e59cdf466bf7908110f309200ae4e4f47fd4fd7bc6fd933924b072fa79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e15098e332fd27b0948bbdbb2fa592205f01521413605557085bcef124e124f9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.cc").write <<~CPP
      #include <cstdlib>
      #include <cstring>
      #include <ctime>
      #include <string>
      #include <iostream>
      #include <vector>

      #include <marisa.h>

      int main(void)
      {
        int x = 100, y = 200;
        marisa::swap(x, y);
        std::cout << x << "," << y << std::endl;
      }
    CPP

    system ENV.cxx, ".test.cc", "-o", "test"
    assert_equal "200,100", shell_output(".test").strip
  end
end