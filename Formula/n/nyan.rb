class Nyan < Formula
  desc "Colorizing `cat` command with syntax highlighting"
  homepage "https://github.com/toshimaru/nyan"
  url "https://ghfast.top/https://github.com/toshimaru/nyan/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "9aedf339d62bb9fd3d83256228354990320b61413672950b63ea424053bbd73c"
  license "MIT"
  head "https://github.com/toshimaru/nyan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8e9b3833088f3db2411296a60a99173107d6e2176322698c0a160d431219e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8e9b3833088f3db2411296a60a99173107d6e2176322698c0a160d431219e65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8e9b3833088f3db2411296a60a99173107d6e2176322698c0a160d431219e65"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3ac2f67dbc35963b33657a3f99a4743da90b531778d78cbd3d6d00821c36d4f"
    sha256 cellar: :any_skip_relocation, ventura:       "f3ac2f67dbc35963b33657a3f99a4743da90b531778d78cbd3d6d00821c36d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238bbab1e8de95171fb84e4a2647ad46e97b73a4de1b30556c033a475cfe51f8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/toshimaru/nyan/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nyan --version")
    (testpath/"test.txt").write "nyan is a colourful cat."
    assert_match "nyan is a colourful cat.", shell_output("#{bin}/nyan test.txt")
  end
end