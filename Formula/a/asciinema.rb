class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/f1/19/45b405438e90ad5b9618f3df62e9b3edaa2b115b530e60bd4b363465c704/asciinema-2.4.0.tar.gz"
  sha256 "828e04c36ba622a7b8f8f912c8f0c1329538b6c7ed1c0d1b131bbbfe3a221707"
  license "GPL-3.0-only"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "393a402f4c28a3aed2db166e5fff6ea6cce93af5b3f6c03af4f23d9f79fb0fe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43e7a7f5bed84cca809d1d2d6b1ccd93ec53b33e35d628d3ff4d4d01592e8ec4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11aa0f514bcbae441f7ac420a8aa34df9197f3124bdcb95a08d4179f3235fa08"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9c437d7e2229f1ca12f37fb851d832046f8809f0cfee59479d85d719f02b59b"
    sha256 cellar: :any_skip_relocation, ventura:        "d12c60fff4c98c2b3703e8f13b5f3122c2d77447d9be0aceef1d66f2b7adb7a1"
    sha256 cellar: :any_skip_relocation, monterey:       "53402504d5c8b0533289c2ec53618c6e34ecfcf6c84eb753a14a094a5c36d8ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b922f833eefb8fee5dc01fe81bf68f146a06ec251cbbcbdf7689e04b87345f3"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to link your install ID", output
  end
end