class PyqtBuilder < Formula
  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/af/9b/3ee5d8f46b41e81914ee64795da3469782a5c69d67bf7efba82770f81f00/PyQt-builder-1.16.0.tar.gz"
  sha256 "47bbd2cfa5430020108f9f40301e166cbea98b6ef3e53953350bdd4c6b31ab18"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3b07ba04d94369bb4bb119a9a15274f97f05ee4c0a2fb45b76becd8aa83891f9"
  end

  depends_on "python@3.12"
  depends_on "sip"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system python3, "-c", "import pyqtbuild"
  end
end