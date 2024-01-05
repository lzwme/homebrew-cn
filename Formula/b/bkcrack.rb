class Bkcrack < Formula
  desc "Crack legacy zip encryption with Biham and Kocher's known plaintext attack"
  homepage "https:github.comkimci86bkcrack"
  url "https:github.comkimci86bkcrackarchiverefstagsv1.6.0.tar.gz"
  sha256 "b25ea94c102e86b3c81f70a4d9a2145e7e9d56f00a6fce407ae71733e0f834f2"
  license "Zlib"
  head "https:github.comkimci86bkcrack.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "416350b9e367dcb99369c05344c67ecfc46a008456ec914071a8649f67d482b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c8bbdbedcd3760ed63317e94af22b3b547b320b6ef8cef347be93eac73ff289"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d09db476ecd658240bd7f8113ca8eb963ede24b810cd5e7828f6c938373272a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "de8a30705814b14689aee63220466a8c94524acc2e1e8b0317025512462c7022"
    sha256 cellar: :any_skip_relocation, ventura:        "ecf5a5910849bb80402329b1825fc5107659f48bb04c617e6276e9fa6307aabc"
    sha256 cellar: :any_skip_relocation, monterey:       "fa4eb43b1b805a2aa9b3152c6067776d408a606b98226df57932611c3e19bb85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe0cff6ec684085f8c323c9dd248975dc8c9a5416253b43d99e0c5ee7c1b81a4"
  end

  depends_on "cmake" => :build

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