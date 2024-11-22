class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https:github.comalanxzrabbitmq-c"
  url "https:github.comalanxzrabbitmq-carchiverefstagsv0.15.0.tar.gz"
  sha256 "7b652df52c0de4d19ca36c798ed81378cba7a03a0f0c5d498881ae2d79b241c2"
  license "MIT"
  head "https:github.comalanxzrabbitmq-c.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e101c4dc4a3661e074f43e351d755b4bf004bf0dc0c3cb89779b071a97be3324"
    sha256 cellar: :any,                 arm64_sonoma:  "2a87e5561540b3c5b5e29907aabc4bb87b003ab1aa2359cf803ef43182b61730"
    sha256 cellar: :any,                 arm64_ventura: "08984332c63cb740fab4eaf803679260938a20cd0d0c8a0e68f94abef6f89927"
    sha256 cellar: :any,                 sonoma:        "3fb725256372918473d3bcfbdbab2f86f90a218f4f67e491f49fa27fe870b209"
    sha256 cellar: :any,                 ventura:       "77ca0d167a6af5b3f22e8557336dba784305505edbae2c469b5e0d468a5bd621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "835505a60c65b2630a70ded7eedd09fa35a48102e5b65509a0af22a26d204a2a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"
  depends_on "popt"

  def install
    ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_API_DOCS=OFF",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_TOOLS=ON",
                    "-DBUILD_TOOLS_DOCS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"amqp-get", "--help"
  end
end