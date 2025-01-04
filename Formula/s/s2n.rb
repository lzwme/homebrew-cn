class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.10.tar.gz"
  sha256 "6f13d37658954cc24f4eb8c7f30736e026ce06f8c9609f7820ab82504618a98d"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2aa0b1cb41619dc00e85fa348f5f0f2707e440d738d3401b5bdb708b168be535"
    sha256 cellar: :any,                 arm64_sonoma:  "a27ef26012b0a4a410d087089760e6d9b0e3e8a156973a473e8b8c2457c0d5b4"
    sha256 cellar: :any,                 arm64_ventura: "ef9cc5414d9055bc06d65d242f08eca96a7eca06bd77393dd69d5a96a837df34"
    sha256 cellar: :any,                 sonoma:        "115b3955156edbb38c09021b73107361467644ebf06fe177c8f4b4c8c18db0cb"
    sha256 cellar: :any,                 ventura:       "b3991e0d8bcf67aae40128edecd7abb05430e0765309ff659b21eb56637d09c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a97c06f8575fcc1577ca0e3f287a17cc3563bf8acb27f6fcf62c3f9a879a6f"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system ".test"
  end
end