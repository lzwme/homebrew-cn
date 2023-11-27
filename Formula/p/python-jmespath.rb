class PythonJmespath < Formula
  desc "JMESPath is a query language for JSON"
  homepage "https://jmespath.org/"
  url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
  sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "564c13f3ce0c425376327bf707320acf5298907b1f9beda1e57f47f8217dcc56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35d2a9e88bac6f2a88f1aa8ae630fc947eb7b3bc17d7f79cad4cebac55f7426a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c965a668a83ab01db8377140c536c93bcab34d3f7bb3f7a0c0c158432b96efca"
    sha256 cellar: :any_skip_relocation, sonoma:         "88ff9fc56e70e81fe55c2afc627da645ca7ba9b2b1f0e9a0708240dc54bb4d10"
    sha256 cellar: :any_skip_relocation, ventura:        "eedd58ed02a7eb330fee80448504e6cc66c5101e6941f533474ec000fe2c2ff7"
    sha256 cellar: :any_skip_relocation, monterey:       "4a08cb4d05b33e611fa45cccdbf4668286133f4919e0d0f06ed89f9305e8b7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c75e71c63aeab76794f3b4552400cd54884fdb0eae11b0133b5077cc943c3e4"
  end

  depends_on "python-setuptools" => :build
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

    bin.install_symlink "jp.py" => "jp"
  end

  def caveats
    <<~EOS
      To run `jp`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from jmespath import functions"
    end

    test_file = testpath/"test.json"
    test_file.write "{\"key\": \"value\"}"
    output = shell_output("#{bin}/jp -f #{test_file} key")
    assert_equal "\"value\"", output.chomp
  end
end