class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.4.11.tar.gz"
  sha256 "82650a16ed3523aafe33c289dfe316df4a53d73c4d732a90d5e8f30e93a952a2"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9653c60260cc1815b3517a0b500c443d759fc662ea262025735ee835f1ab66dc"
    sha256 cellar: :any,                 arm64_ventura:  "a095cf5dbf276ad62683c89a4c1db7431caf7b2934793e7735669af46422a208"
    sha256 cellar: :any,                 arm64_monterey: "54d4523f680515c6214740b98335baed696c06ea1f6a8e28ee239bf2a80a963d"
    sha256 cellar: :any,                 sonoma:         "6ed891b7f284a1b0eb2a5c4cf299ccea4d8a9c14f1d0a02c43eec78b7acf9e44"
    sha256 cellar: :any,                 ventura:        "863cdd51067bc1d56cb26d880c2edca2821c2f6bd55d89bb7d68544bc251c5d9"
    sha256 cellar: :any,                 monterey:       "6509dcae5b2f22315c51605809e419600d07ce4a7e50d7f3ee50c425b351b42b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9429601d4c57d69982e287150e14bd88dd74693de4249a74a30ca622b6151d3b"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "buildstatic", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "buildstatic"
    system "cmake", "--install", "buildstatic"

    system "cmake", "-S", ".", "-B", "buildshared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system ".test"
  end
end