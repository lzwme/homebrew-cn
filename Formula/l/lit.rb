class Lit < Formula
  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/f3/37/be14bf2cabacc40557a03cf4789d9a3335bf515b0ec3a655fdc84cae4779/lit-23.1.0.tar.gz"
  sha256 "6fd50e0ca6fac61f4a672e9f30154edcab3d17c98aeb8202ac709bc353fe331f"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83970a9d30e801723d1ddaa7366c45d0513006687b2957ab55decfb8af6017cc"
  end

  depends_on "llvm" => :test
  depends_on "python@3.14"

  conflicts_with "luvit", because: "both install `lit` binaries"

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
    ENV.prepend_path "PATH", formula_opt_bin("llvm")

    (testpath/"example.c").write <<~C
      // RUN: cc %s -o %t
      // RUN: %t | FileCheck %s
      // CHECK: hello world
      #include <stdio.h>

      int main() {
        printf("hello world");
        return 0;
      }
    C

    (testpath/"lit.site.cfg.py").write <<~PYTHON
      import lit.formats

      config.name = "Example"
      config.test_format = lit.formats.ShTest()

      config.suffixes = ['.c']
    PYTHON

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