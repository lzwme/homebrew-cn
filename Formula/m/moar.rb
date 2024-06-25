class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.24.3.tar.gz"
  sha256 "66157f547cffbcbf3cede581f4e232ed991213055157a3a075dc789ea1f7475a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "117b2641d677a3d122527a81f50e328e49b5336b516a753fba327748fbb7e3d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "117b2641d677a3d122527a81f50e328e49b5336b516a753fba327748fbb7e3d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "117b2641d677a3d122527a81f50e328e49b5336b516a753fba327748fbb7e3d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "67b651d81a437975fdf9f1b4eb8653355a1fc18fe478c1a7bc4dd73fc4cd5fb0"
    sha256 cellar: :any_skip_relocation, ventura:        "67b651d81a437975fdf9f1b4eb8653355a1fc18fe478c1a7bc4dd73fc4cd5fb0"
    sha256 cellar: :any_skip_relocation, monterey:       "67b651d81a437975fdf9f1b4eb8653355a1fc18fe478c1a7bc4dd73fc4cd5fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea4a72911e6c3ce9fc735663aefe20c93f4b385134ffa129b75724ef7cd8a410"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}moar test.txt").strip
  end
end