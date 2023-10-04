class PythonPackaging < Formula
  desc "Core utilities for Python packages"
  homepage "https://packaging.pypa.io/"
  url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
  sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  license any_of: ["Apache-2.0", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d34276bbed1ee6cdbd74abd93ee6290824ea3e7710d2157f7fe94ff827bb80b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54b10d27e83d2a476aaba8bf58d722f256500517f8c108278be5f9d4b53c887b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49c3dfc250cae00e7b0a71b08d3529f550b07cc45a7b1cb438e95c82e2cb6325"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7b8b89df34cd1ddbc21882db84fde64b66166505dbf81dc4de624e1105e5d6b"
    sha256 cellar: :any_skip_relocation, ventura:        "18f59d57b14ed6e05cf6508a1324cb2ded25f3c5e978423275581968ee38176f"
    sha256 cellar: :any_skip_relocation, monterey:       "fc088b95a87189c4a2d44a69d2e05f5325b0ef8d11e3b5f9b35764fda9e8ee57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92815d751457504c0a76b357fb08a25387e86f52d3bada9af839dd7ef94d3a10"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

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
      system python_exe, "-c", "import packaging"
    end
  end
end