class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https:octomap.github.io"
  url "https:github.comOctoMapoctomaparchiverefstagsv1.9.8.tar.gz"
  sha256 "417af6da4e855e9a83b93458aa98b01a2c88f880088baad2b59d323ce162586e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "22906bdbc68e6f89ce4822236c01ccd5841c23c886d246b3134b55e4116ba221"
    sha256 cellar: :any,                 arm64_ventura:  "f7494aecb65eb2430983ffa409df99f5831553fd29da3ebcb5140a7a30095d97"
    sha256 cellar: :any,                 arm64_monterey: "229cd1d731bb01140ce736fcfcf97e8c0f9e270233339e57c834b49a77b86331"
    sha256 cellar: :any,                 arm64_big_sur:  "4e1d89df8bbf973444851efd60273558eb8d3888c85d199f3350f0b4cb66e977"
    sha256 cellar: :any,                 sonoma:         "70377cb3bb39a310e175470424f29aca9df35c42a90074c7b9810a0205055df5"
    sha256 cellar: :any,                 ventura:        "111cd9c4a3df4d3f97216013795d7c4a2f853c218f6bbc8bef52f9da2531f212"
    sha256 cellar: :any,                 monterey:       "b46273db2c913a4952be98b73811b6fc40683c37ccac8e2d4c8b3eb369886154"
    sha256 cellar: :any,                 big_sur:        "abf7287e17a8304b8429085bab4de3e99e484926db38148cbbc20d007bdb73a3"
    sha256 cellar: :any,                 catalina:       "280ae6e1d5528290fda17ad0522e1e7d15182ec9551ec4dec051ad8feddf232b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c17e275597d5b91081dc127ec9bf16d5baba52fddecf1b011523ed57a5d1cc8"
  end

  depends_on "cmake" => :build

  def install
    cd "octomap" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <cassert>
      #include <octomapoctomap.h>
      int main() {
        octomap::OcTree tree(0.05);
        assert(tree.size() == 0);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}",
                    "-loctomath", "-loctomap", "-o", "test"
    system ".test"
  end
end