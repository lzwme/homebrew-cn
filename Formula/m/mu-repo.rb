class MuRepo < Formula
  desc "Tool to work with multiple git repositories"
  homepage "https:github.comfabiozmu-repo"
  url "https:files.pythonhosted.orgpackagesfc3f46e5e7a3445a46197335e769bc3bf7933b94f2fe7207cc636c15fb98ba70mu_repo-1.8.2.tar.gz"
  sha256 "1394e8fa05eb23efb5b1cf54660470aba6f443a35719082595d8a8b9d39b3592"
  license "GPL-3.0-only"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c748c62da7e9983b7a3a1ee64cb134d206ce74d2ca8b8145752435e63a266ea7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a44cf755ab0df3eb8514d0eb57455d54638506e8fd24e2185255aaa6246fd28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79d62e4af4026aaf23d8442840746da1a71b76bc35d3fb6de67cbac0beca7f4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2215863f307d1d2d3bc095737064344c92a6dff1d26a8da3db967dfa57b653e3"
    sha256 cellar: :any_skip_relocation, ventura:        "ad5fc9fc60840940996bcf49dce4eeba966546e0bf67c59e41195b85f030f1dc"
    sha256 cellar: :any_skip_relocation, monterey:       "dc77f5c90c78bb093ffe620fb66858a0678f047ba56657deeae049b4933cdfe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac9b567238f2724f02f1961984261e1fb811c1067832252ffc889fb110ad1c8"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  conflicts_with "mu", because: "both install `mu` binaries"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_empty shell_output("#{bin}mu group add test --empty")
    assert_match "* test", shell_output("#{bin}mu group")
  end
end