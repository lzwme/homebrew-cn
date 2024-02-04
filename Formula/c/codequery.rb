class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https:ruben2020.github.iocodequery"
  url "https:github.comruben2020codequeryarchiverefstagsv0.27.0.tar.gz"
  sha256 "c03b86f9f5a8f5373862efaef6bddd18a15e5786570a93f0310725ecc5d74ff3"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a5e11e34f169ec046b0782e239797fc6dc7cb35a76bc9c38fd3c17bf0ee1a5e"
    sha256 cellar: :any,                 arm64_ventura:  "931c4d911a4625bede72b3115ae1ad147e8ac18b0240aec2e94bb3a2bfeee08c"
    sha256 cellar: :any,                 arm64_monterey: "e590fa7410e46d1c47288d4a9ef93e410d83cbbb04fc7360035f5f39c2710685"
    sha256 cellar: :any,                 sonoma:         "9a88afb249e743ab0f8cb9521a05aa155fd7b6d73e5da8a45fd1f6faef60235e"
    sha256 cellar: :any,                 ventura:        "1431ce53f49494ccae4d9f133c8d706d0f5579c4f65c0ba82df80d0098ca507b"
    sha256 cellar: :any,                 monterey:       "a54c3da40028710b0b16aa09b9b2dd6a0c9b8d569dc7cb8f4b483731e2db4ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2d4afb2e96403a1dd4553877ada1d21cf749471a2d8c12a9ec2d6e278e9b83b"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test"
  end

  test do
    # Copy test files as `cqmakedb` gets confused if we just symlink them.
    test_files = (pkgshare"test").children
    cp test_files, testpath

    system bin"cqmakedb", "-s", ".codequery.db",
                              "-c", ".cscope.out",
                              "-t", ".tags",
                              "-p"
    output = shell_output("#{bin}cqsearch -s .codequery.db -t info_platform")
    assert_match "info_platform", output
  end
end