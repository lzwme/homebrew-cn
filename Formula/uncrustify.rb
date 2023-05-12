class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://ghproxy.com/https://github.com/uncrustify/uncrustify/archive/uncrustify-0.77.0.tar.gz"
  sha256 "d48828e7a2bbf6de0813807ad679c256680299102915f2943e60bb2152120d8f"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0231d055d8285a3cf0f689b7cf77b4ab94fd158bbb86e9c504cd474b2277f028"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5369ffa73c5d657af401e92a19aeff25fbb56bdc352049d24c1f8d78580b96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b5a4f56f1bedf2c8e8ce746a0b2f057b8e99b3ecdbb9f3abcf2e975be00a652"
    sha256 cellar: :any_skip_relocation, ventura:        "3a66c6b26572065740b9c835b3cb01a494c9a35e1246f9e9814168eaa8414f2c"
    sha256 cellar: :any_skip_relocation, monterey:       "5940e99e05c07bac672821da0bae4c7f6bffcaba70562e87e74103d1504f09b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6aaff5a37aabdb14bde0cf9068f8287a4653f5665179b57bf7447edc79e59190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f22f91f917748972b2596a8b4f1d754c4871b977e850ed9d3dee94f9fc5ae2f8"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    doc.install (buildpath/"documentation").children
  end

  test do
    (testpath/"t.c").write <<~EOS
      #include <stdio.h>
      int main(void) {return 0;}
    EOS
    expected = <<~EOS
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    EOS

    system "#{bin}/uncrustify", "-c", "#{doc}/htdocs/default.cfg", "t.c"
    assert_equal expected, File.read("#{testpath}/t.c.uncrustify")
  end
end