class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "2ba5a754946245714c2b0a3e875107788730eafecb8f4d0d3e1fcf8f6f906469"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a24fec08f9b548893f88702a8ad38c7db8c625598caa93605a7e482775ba7ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "901a0cdf247a0278835f8b586a3e2adeba5e02fc0ff3e9ab9d26676119245930"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74a5b89059c3910aace6722bc551baf5e28cd603a4cf8f71a1a98e6a675f47bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "186590eb268e01eb3e07ee54fcbe6e62541b195bbb727f26c809625fe10b446e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b1c67e0800fe5b569b0d0955533212c6a55829583aefd63017986bbcb3b3a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "971920b37f7d66d589cc654c03fb9e4d972f24bd9a90ce4a3659faffa304507f"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/tools/shell/lbug"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbug --version")

    # Test basic query functionality
    output = pipe_output("#{bin}/lbug -m csv -s", "UNWIND [1, 2, 3, 4, 5] as i return i;")
    assert_match "i", output
    assert_match "1", output
    assert_match "2", output
    assert_match "3", output
    assert_match "4", output
    assert_match "5", output
  end
end