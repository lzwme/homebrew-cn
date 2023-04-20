class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/89/6b/2114e54b290824197006e41be3f9bbe1a26e9c39d1f5fa20a6d62945a0b3/Pygments-2.15.1.tar.gz"
  sha256 "8ace4d3c1dd481894b2005f560ead0f9f19ee64fe983366be1a21e171d12775c"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92b2ad11ce08f71667b54232ee5bddc33f3b372ad748ab0806ebbbd9d916e7a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83e6fea1e208af0e77eb8e74497c24faff53cc42b8fa870c3ea422a7385da417"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc979c7446c61adbd9b379ad185482aabe0d35cde631c1161ebbbfe4c6439242"
    sha256 cellar: :any_skip_relocation, ventura:        "f89698b70a24a363b0bc6eb38976a529e8ad25705d1c1d34b3ca7670b0240fb4"
    sha256 cellar: :any_skip_relocation, monterey:       "ad6129dce8967aab592decbbd8a6d094dc3137e13fa435d1be1a818cc170f8c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "46fe5b61cc882b692163be9618aba19c9baed269370d3ba0d8ffa964fb963ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e6830e5f345bea7b011a79833b298058215df4ed0882fd4ed100434101855ed"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  def pythons
    deps.select { |dep| dep.name.start_with?("python") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", "--prefix=#{libexec}", "--no-deps", "."

      site_packages = Language::Python.site_packages(python_exe)
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-pygments.pth").write pth_contents

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install libexec/"bin/pygmentize" => "pygmentize-#{pyversion}"

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "pygmentize-#{pyversion}" => "pygmentize"
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
      print(os.getcwd())
    EOS

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)

      system bin/"pygmentize-#{pyversion}", "-f", "html", "-o", "test.html", testpath/"test.py"
      assert_predicate testpath/"test.html", :exist?

      (testpath/"test.html").unlink

      next if python != pythons.max_by(&:version)

      system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
      assert_predicate testpath/"test.html", :exist?
    end
  end
end