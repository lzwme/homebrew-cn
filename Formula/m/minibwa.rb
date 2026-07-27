class Minibwa < Formula
  desc "Successor of BWA-MEM for short-read alignment"
  homepage "https://github.com/lh3/minibwa"
  url "https://ghfast.top/https://github.com/lh3/minibwa/archive/refs/tags/v0.5.tar.gz"
  sha256 "994db9f7ee86781545a974f81938f962acbf5605a1a85255bf65dff59e3bae16"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6949707cf4cfc018df840de49a1993fe6b3adb29bfda914e32461587b36d841"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28bca8a405fd45e445ecaa16284badc753a4d4211be98ae893c8c4e1361092b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76a52b3268b786fcb383d264be49598ddbf9c867b72082c7868cadffc22cf1d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "86e2fe1b9fdeda6de27b77cfdb85c618d262ef69268bec93540ca2ceb050dba6"
    sha256 cellar: :any,                 arm64_linux:   "bc22b665bd642bb193b14bec0a19e8a95bf5816a3a3472a877cc408ca9d58904"
    sha256 cellar: :any,                 x86_64_linux:  "a028cf59c43a5f7c428c5a5c66865152ca70444bbd8692fb66f4bdc29fe694cb"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "gpl=0"

    bin.install "minibwa"
    man1.install "minibwa.1"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath

    system bin/"minibwa", "index", "chrM-human.fa.gz", "chrM-human"
    assert_path_exists testpath/"chrM-human.l2b"
    assert_path_exists testpath/"chrM-human.mbw"

    output = shell_output("#{bin}/minibwa map chrM-human chrM-read_1.fa.gz chrM-read_2.fa.gz 2>/dev/null")
    assert_match "@SQ\tSN:chrM", output
  end
end