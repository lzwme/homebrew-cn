class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/ac/6a/6122e5f9a08f8b195cbc9d89e153e27e6a068e44de4a7e6494754a15e028/rdiff-backup-2.4.0.tar.gz"
  sha256 "1721ab8ae1f1e163117d776d52daf2ee53cb9b7e96ec749ee2bd5572ccf55935"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0987b90ee50e738463116cac2dadd4513e1b70475cc761c7d5951c6670fec291"
    sha256 cellar: :any,                 arm64_ventura:  "e878eddd155f0a8289f3af7596f41e2629f4cba3c01f6eb44864379f032ae782"
    sha256 cellar: :any,                 arm64_monterey: "295bea3f09286bada7313def5d1b85f694f6622da4fb6e1e50dd9a151591c5a4"
    sha256 cellar: :any,                 sonoma:         "efdd668076273bc8e7549345688ce685216b5991d1f0179fc5564daf8dbaa7d9"
    sha256 cellar: :any,                 ventura:        "63353112b6fa2c6f4acebdb9ba601398867fc31f651410e9e4178a27d150da34"
    sha256 cellar: :any,                 monterey:       "78a13568f9fe661e6d73b0edd2f75f72aa49704372bb6866cff4d1c3c472d2d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab812d3b5219a0ea3ed048ce216a04af62b77b44fb5f258dd286d22339a7f3bd"
  end

  depends_on "librsync"
  depends_on "python@3.11"
  depends_on "pyyaml"

  def install
    python3 = "python3.11"
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end