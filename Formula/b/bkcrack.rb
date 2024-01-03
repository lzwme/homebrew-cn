class Bkcrack < Formula
  desc "Crack legacy zip encryption with Biham and Kocher's known plaintext attack"
  homepage "https:github.comkimci86bkcrack"
  url "https:github.comkimci86bkcrackarchiverefstagsv1.6.0.tar.gz"
  sha256 "b25ea94c102e86b3c81f70a4d9a2145e7e9d56f00a6fce407ae71733e0f834f2"
  license "Zlib"
  head "https:github.comkimci86bkcrack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3cbba7e001526e8e7aaccbf5b351f7d83626935d6f4c2d04241dfab63d44785"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16bb95e206abfa801ea75447076f4a97e826c3b405bc6a877bb6d5f0ebf4ad62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42aa053f8fc4d5f54767db1c449fd81ad8ddb8fc031a9b7945ba29f17de0f4f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b0c2a35bb8c781dcb46eb714e1f85e2f4401153565c9d4175438125a032291d"
    sha256 cellar: :any_skip_relocation, ventura:        "7ca11c025066112448d7c2707ab579d9a705516ff98eb4300522d6d49386624c"
    sha256 cellar: :any_skip_relocation, monterey:       "ee4a6a9067f634dd46bc145f04c29cbcf8a2dff573e15800f3f714911c14e772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4703bf4f5c99320658c6c7c39d9fe3de95bb335e8ac80582dba753f69dc965ae"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "buildsrcbkcrack"
    pkgshare.install "example"
  end

  test do
    output = shell_output("#{bin}bkcrack -L #{pkgshare}examplesecrets.zip")
    assert_match "advice.jpg", output
    assert_match "spiral.svg", output

    assert_match version.to_s, shell_output("#{bin}bkcrack --help")
  end
end