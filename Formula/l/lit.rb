class Lit < Formula
  include Language::Python::Virtualenv

  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/60/4a/5f753dd7d5127fea0d4fe0671581f473d13c4c0dec98c527eb9eb4445d71/lit-17.0.3.tar.gz"
  sha256 "e6049032462be1e2928686cbd4a6cc5b3c545d83ecd078737fe79412c1f3fcc1"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9e9076d8515b731c33b8aaa99118dfd28a850b4b118ee21f5be9a2f0db8953f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a6ede213974b5755a70e966689ed73eafa57571a44553cb8fc8bfa973198b29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6615976b3e198979476399bf361aa29fb3aa7f63a7cb8f4bbdf78bcd17812d4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e3697205c7566e646bb95d7c690ec330b4e87c8cc756c9e652bb03b9ef2443c"
    sha256 cellar: :any_skip_relocation, ventura:        "0b2818542b613d66299bdae0ec2d59223baedd6c62b4e948417f543a5137d612"
    sha256 cellar: :any_skip_relocation, monterey:       "b037ceba6e5393391fe4f925f6b315feb4333ecde613868d3d4f740ac81d09c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e039029bc74baee46c9fb960c4c378f77c9d70b220da9fe53d831bdbde94e48d"
  end

  depends_on "llvm" => :test
  depends_on "python@3.11"

  def python3
    which("python3.11")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."

    # Install symlinks so that `import lit` works with multiple versions of Python
    python_versions = Formula.names
                             .select { |name| name.start_with? "python@" }
                             .map { |py| py.delete_prefix("python@") }
                             .reject { |xy| xy == Language::Python.major_minor_version(python3) }
    site_packages = Language::Python.site_packages(python3).delete_prefix("lib/")
    python_versions.each do |xy|
      (lib/"python#{xy}/site-packages").install_symlink (lib/site_packages).children
    end
  end

  test do
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin

    (testpath/"example.c").write <<~EOS
      // RUN: cc %s -o %t
      // RUN: %t | FileCheck %s
      // CHECK: hello world
      #include <stdio.h>

      int main() {
        printf("hello world");
        return 0;
      }
    EOS

    (testpath/"lit.site.cfg.py").write <<~EOS
      import lit.formats

      config.name = "Example"
      config.test_format = lit.formats.ShTest(True)

      config.suffixes = ['.c']
    EOS

    system bin/"lit", "-v", "."

    if OS.mac?
      ENV.prepend_path "PYTHONPATH", prefix/Language::Python.site_packages(python3)
    else
      python = deps.reject { |d| d.build? || d.test? }
                   .find { |d| d.name.match?(/^python@\d+(\.\d+)*$/) }
                   .to_formula
      ENV.prepend_path "PATH", python.opt_bin
    end
    system python3, "-c", "import lit"
  end
end