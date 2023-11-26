class Diceware < Formula
  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/2f/7b/2ebe60ee2360170d93f1c3f1e4429353c8445992fc2bc501e98013697c71/diceware-0.10.tar.gz"
  sha256 "b2b4cc9b59f568d2ef51bfdf9f7e1af941d25fb8f5c25f170191dbbabce96569"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82ca3faf9b2081fe0ce9cbdd22815e9d6b505871e18fff797c608098b723db5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d6c651c8851db194236933cd9cf6940248a957cfe81923318230266c14c1e57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f017cb3dba65aa43dc3ae9c79ec1d53143429f7a22597369f0af8d397f85e45"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e14e9be26df58bed11a2777f36c9fd64f5e212b58056bbb5578d6bac12cabb1"
    sha256 cellar: :any_skip_relocation, ventura:        "5bd06a45991cd6ade1372710f3b5c89fd651cb96b8ad5bffd23bfed92036a4f5"
    sha256 cellar: :any_skip_relocation, monterey:       "303ce1d86d46e1c4bd7b1713a9a4036bfa2be3516f9708ecf802973b25737707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c94513ee25d0bc75a5199e701e03b294d2bede4eefbdf625408a9aa7329ddee8"
  end

  depends_on "python-setuptools" # remove for v0.11+
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
    man1.install "diceware.1"
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end