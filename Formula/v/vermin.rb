class Vermin < Formula
  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  # pypi sdist issue, https://github.com/netromdk/vermin/issues/243
  url "https://ghproxy.com/https://github.com/netromdk/vermin/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "e4b6ca6f3e71b0d83a179dc4a4ba50682f60474cf8c948ba9f82e330f219ff4a"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de20468b870e639343ad234f18d9018a908918e564bad6ce7195fb686ab96401"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b189d96bd21b141dd0ad3fa8d5449c72076202ca2890af8c6f6eec7bb514e25c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d16f1fc95033fd33a03535af4038165c67db5cbd11fe51962da37f42dc18096d"
    sha256 cellar: :any_skip_relocation, sonoma:         "162ef8421922d36df066859ec7dd5ca6a64aa75733e5fe6a2eb60f92e8e975a5"
    sha256 cellar: :any_skip_relocation, ventura:        "1572e3bcd97121ea49832591a45c4559c10727db43f8ab202fe0e297b12f087c"
    sha256 cellar: :any_skip_relocation, monterey:       "6cda0ed69fefec865c12698b3cb366c06288a98e43c237652ce0715af16154bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a89e102af8f9c60ef26fe7c0b8e37451c76c5d874763e1199b0909fc4311e031"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/vermin --no-parse-comments #{bin}/vermin")
      Minimum required versions: ~2, ~3
      Note: Not enough evidence to conclude it won't work with Python 2 or 3.
    EOS

    assert_match version.to_s, shell_output("#{bin}/vermin --version")
  end
end