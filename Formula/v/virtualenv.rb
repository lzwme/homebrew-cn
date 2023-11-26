class Virtualenv < Formula
  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/ac/fe/028d5b32d0a54fe3ecac1c170966757f185f84b81e06af98c820a546c691/virtualenv-20.24.7.tar.gz"
  sha256 "69050ffb42419c91f6c1284a7b24e0475d793447e35929b488bf6a0aade39353"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68564b034615b5f8b40e1b8a9622e70c9ee94ea056594bcd52c5cc82ee38e892"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c31e833bf7a9c7683f3b431a4865c8ab435b6497a71462b569b29f25d245688"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "278e4b93b61ebf00db3e84cf87a381d220718eb02c90f33cecef1aa25d655b67"
    sha256 cellar: :any_skip_relocation, sonoma:         "38ad24d9c9c9563931ac6c4474a64f0ce6285d13c1366a97941b0dc7d72d0adb"
    sha256 cellar: :any_skip_relocation, ventura:        "b436fe63ddfd02705abef4dcb95f7c7bcee81d7af3c87db2eeff0c0cfd165b39"
    sha256 cellar: :any_skip_relocation, monterey:       "9287c643fed193633a84fa05c18f84afbd6277fa6fb92ecb05da45d2e3bfd55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "011cf0227f47de297f92a7844f6414c32ce5be4605dd5f34beace2c4b55b06c4"
  end

  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python-distlib"
  depends_on "python-filelock"
  depends_on "python-platformdirs"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end