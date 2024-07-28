class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https:www.oneapi.ioopen-source"
  url "https:github.comoneapi-srconeDNNarchiverefstagsv3.5.2.tar.gz"
  sha256 "e6af4a8869c9a06fa0806ed8c93faa8f8a57118ba7a36a93b93a5c2285a3a49f"
  license "Apache-2.0"
  head "https:github.comoneapi-srconednn.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "099a37a561a6d1ca022325ed65b82428a9c63709c131d471b274c87f1f84b776"
    sha256 cellar: :any,                 arm64_ventura:  "29509dd038121357669c9c4c1681ccadbaa618d340438847159de1596910e855"
    sha256 cellar: :any,                 arm64_monterey: "18c0ba89f37c12aa365d9fdc7ae8365ddd0039521e9f41cb99ff0f395f10a5b9"
    sha256 cellar: :any,                 sonoma:         "9c74fe4853d04a1559610971abdfc8cb20960614e8ef1a4fcc9ae608b2e89ec7"
    sha256 cellar: :any,                 ventura:        "54235a7300c474b7c4efcfb8be07e48db21f582a919572361466641b25df092e"
    sha256 cellar: :any,                 monterey:       "309feefa5022033f61124565e478172b168761eef4efac9358c096a047066b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dfd102b293ffd201d545f8d48aec945bd458698f65df65ee11a46f91313889b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <oneapidnnldnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system ".test"
  end
end