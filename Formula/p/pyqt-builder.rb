class PyqtBuilder < Formula
  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/21/e9/5ee4d76d3f4c566b090924e36da067748db948a5faeff4142d149a4d5a15/PyQt-builder-1.15.3.tar.gz"
  sha256 "5b33e99edcb77d4a63a38605f4457a04cff4e254c771ed529ebc9589906ccdb1"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da3c4b8210552102e47e9a5beca1f809e4b2e9c88c907e488b46da5ef1cf7a05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "311f0199234512ed20e85d751247947c8e45f2773f051ceca0d5eb186acffd59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "286ea3c067ee91eb94ce64ba84f241d4c881a2fa36310aeb91a56e19c3345f45"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a5b5bab5dc224a024b1fa7893aa2551cc380af840f97239b43325ae925b7215"
    sha256 cellar: :any_skip_relocation, ventura:        "acfe6256997886fc065bdf2d024a774e19f372aa7f7883f243ce642288e593f3"
    sha256 cellar: :any_skip_relocation, monterey:       "208f9bed57138f48f1da3c4dedf6cf156034396602bdeb3414ca2938bc82e0af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ffa81c943c238a080e1cfd83e99c355663bfe432d3396a570c0fc2febebf23b"
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