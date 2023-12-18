class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https:avro.apache.org"
  # Upstreams tar.gz can't be opened by bsdtar on macOS
  # https:github.comHomebrewhomebrew-corepull146296#issuecomment-1737945877
  # https:apple.stackexchange.comquestions197839why-is-extracting-this-tgz-throwing-an-error-on-my-mac-but-not-on-linux
  url "https:github.comapacheavro.git",
      tag:      "release-1.11.3",
      revision: "35ff8b997738e4d983871902d47bfb67b3250734"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c1f9e13f15654e854eff1f6d696f86cfbe80a6504109c489a5d79e20f9684ce2"
    sha256 cellar: :any,                 arm64_ventura:  "fe953a2849f1cdf4c2cd4adf5a222bd03ba1c663ad923e30ebd7de35d241a753"
    sha256 cellar: :any,                 arm64_monterey: "a2acb256c03c1e5a4b017f1b8b6636e292670ef28f3e9c557e8cc340e3ba3cf7"
    sha256 cellar: :any,                 sonoma:         "9371e77112081fc1236c81acd2e3323fd07df8c369bd44352daadece50b651bd"
    sha256 cellar: :any,                 ventura:        "91dea807fa06c7956b0f9266b2c4fc126fd93fbf056799a9c7f227067828c982"
    sha256 cellar: :any,                 monterey:       "d74b2a06d76bb4ebd43e75b5406297c2319635f12bde926e76c133b6ba511583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "709c7743ccc5dfb632ce54668083db634a992aebc7052978a9c62ce8598c7400"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"

  def install
    cd "langc++" do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  test do
    (testpath"cpx.json").write <<~EOS
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    EOS
    (testpath"test.cpp").write <<~EOS
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    EOS
    system "#{bin}avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system ".test"
  end
end