class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/refs/tags/4.1.10.tar.gz"
  sha256 "a69fde4fcf16e0d14df0faae35182ee63be369efe8f0fde4bee70afcfc09989a"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f011de3672f9bcdcc22c565198b2fa710f28e73d41aea2e31d7dc0f7fc73bc04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a5a75f4f887774dc981f6cce513d767a35e46beb838a3469edce4e4a6238048"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f264d245216d23e49e1063b177d07b5c5ed35240e818d2c225eedb11b9f92ad"
    sha256 cellar: :any_skip_relocation, ventura:        "16325962d00fc353a8191342d6188764b32c9d78c10da7cea77395dcd71dba8c"
    sha256 cellar: :any_skip_relocation, monterey:       "58b16459a6230452c9624befc85fea2ab056000e9326aa2ea967cc46d7018e0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc682cdde90a9baad83e8ef941d64fb79e411c66ef36a11e138c72dc86d9ee9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91a31ef401d22973c299e53c7659feb0183e3ad39fcbd0779b288eb528c5efc9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end