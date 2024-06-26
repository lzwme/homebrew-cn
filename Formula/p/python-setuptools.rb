class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/0d/9d/c587bea18a7e40099857015baee4cece7aca32cd404af953bdeb95ac8e47/setuptools-70.1.1.tar.gz"
  sha256 "937a48c7cdb7a21eb53cd7f9b59e525503aa8abaf3584c730dc5f7a5bec3a650"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fe0582be6d488285f5975e8cdd91f9897b755ad43d559a158cd251820bb5798"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fe0582be6d488285f5975e8cdd91f9897b755ad43d559a158cd251820bb5798"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fe0582be6d488285f5975e8cdd91f9897b755ad43d559a158cd251820bb5798"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc9555a83b48d201dfdbbe980515e80c8e0fbb757c5a9b7cb82a360f20431480"
    sha256 cellar: :any_skip_relocation, ventura:        "fc9555a83b48d201dfdbbe980515e80c8e0fbb757c5a9b7cb82a360f20431480"
    sha256 cellar: :any_skip_relocation, monterey:       "fc9555a83b48d201dfdbbe980515e80c8e0fbb757c5a9b7cb82a360f20431480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fe0582be6d488285f5975e8cdd91f9897b755ad43d559a158cd251820bb5798"
  end

  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import setuptools"
    end
  end
end