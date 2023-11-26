class PythonHatchVcs < Formula
  desc "Hatch plugin for versioning with your preferred VCS"
  homepage "https://github.com/ofek/hatch-vcs"
  url "https://files.pythonhosted.org/packages/f5/c9/54bb4fa27b4e4a014ef3bb17710cdf692b3aa2cbc7953da885f1bf7e06ea/hatch_vcs-0.4.0.tar.gz"
  sha256 "093810748fe01db0d451fabcf2c1ac2688caefd232d4ede967090b1c1b07d9f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d7c17572aa90c961a51d32f01c9ca96229a29a219e2d124220728ae8950f4c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb2225aeb7d0652ea78b055eebcee949a40fbd532cc58e9424a91b9cfe09eb0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3e773ace2c22ce7ef503fab58602ca8da4a5ea1c6d391b93718c12f5d874836"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c2f475632067ec487a15c7a003678c51e971e2ed1741e0825ae71b0a1873653"
    sha256 cellar: :any_skip_relocation, ventura:        "8d38d1c2c46ebba8f8a6f7c5fc4076c55725ca4078406fd6fab28f12953e46e0"
    sha256 cellar: :any_skip_relocation, monterey:       "c809a6ef08cfedb1c74fb80db6d1374a5977ac4c448d1697d2ac1efb9f6784ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ad459eac02f22df06d581c4ace6f4748379cd4d2ac0cdfa2beeb0cfeee5be3f"
  end

  depends_on "python-hatchling" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import hatch_vcs"
    end
  end
end