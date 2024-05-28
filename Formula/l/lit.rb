class Lit < Formula
  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/20/87/98366aa460de9a1413a41178acb9f83de106208f889fdccf47c5322163ed/lit-18.1.6.tar.gz"
  sha256 "70878fb0a2eee81c95898ed59605b0ee5e41565f8fd382322bca769a2bc3d4e5"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d79c3ff5bc24f53fb5d84a4e46db916e5eb8d787f790ada4bbacd7b2c6aade0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d79c3ff5bc24f53fb5d84a4e46db916e5eb8d787f790ada4bbacd7b2c6aade0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d79c3ff5bc24f53fb5d84a4e46db916e5eb8d787f790ada4bbacd7b2c6aade0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d79c3ff5bc24f53fb5d84a4e46db916e5eb8d787f790ada4bbacd7b2c6aade0"
    sha256 cellar: :any_skip_relocation, ventura:        "9d79c3ff5bc24f53fb5d84a4e46db916e5eb8d787f790ada4bbacd7b2c6aade0"
    sha256 cellar: :any_skip_relocation, monterey:       "9d79c3ff5bc24f53fb5d84a4e46db916e5eb8d787f790ada4bbacd7b2c6aade0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d318e53a5fe192d3fb2fe46806a44a0ea7d46283946e5b64ca825fada65b7ea0"
  end

  depends_on "llvm" => :test
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

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