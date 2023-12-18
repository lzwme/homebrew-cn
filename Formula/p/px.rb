class Px < Formula
  desc "Ps and top for human beings (px  ptop)"
  homepage "https:github.comwallespx"
  url "https:github.comwallespx.git",
      tag:      "3.5.1",
      revision: "53c4faf6708a89d5dd07ac5b994b42e4ae4164b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00f5fd439db844283da0e008553e8c424a0894845ff284486d73bb244d371994"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15e4fbb2f34972283785fd3fdfcd3b075de908847393c66134496a183969f4b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "985f96d22ed17cd64abf10aefd1f2a84d32679ff0986f96ce36fbc19e8e8cada"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c3789f0f91dc0e32d320747da22f232dad95abbcfe9c8e9ac4ae7b2e24f6458"
    sha256 cellar: :any_skip_relocation, ventura:        "a357c3effd8ebb632817107e1281b8957ce8dd003269063e6904b3b4798821cf"
    sha256 cellar: :any_skip_relocation, monterey:       "ee94f13463a500ca3caf282f6618bf230f200d79cf46a3ad6cdff66d8ab67161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4e9861786d4a53cf68888cbd090e2154f1f34762f5af8ade431a0b5620396ba"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  uses_from_macos "lsof"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."

    man1.install Dir["doc*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}px --version")

    split_first_line = pipe_output("#{bin}px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end