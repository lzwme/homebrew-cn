class Lit < Formula
  include Language::Python::Virtualenv

  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/ef/99/419ecd996ca10eed06ea7ba68923c19168c2b373dccba0ecc6645d94cf47/lit-17.0.1.tar.gz"
  sha256 "44867ae576b5790567b120bc3f0d9f021dac9424d1b0840c75acd85f4610ac04"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1aff4c1a6b4df27ab95ba949efdd9feb4616c80603ad0c67f14ca3cc43196b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09bf34c6d1af3de8bfd273ac7ebb5ef7a3683796f85aa948b618bfb39f0f1bd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "665005ef2943c33d34a7af05275929057fefcf6ad5d2f70c3a8aa5155276ed3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8ef146f38179292d78b27aea2f1a6e1e44ea5cbea2da4acd7fecf9405094b87"
    sha256 cellar: :any_skip_relocation, ventura:        "a3d9d72ebcb60db7d955a121b6881074d68c389ec810ac373c72c0f0fbdb6a4e"
    sha256 cellar: :any_skip_relocation, monterey:       "9cc62332b00c6ec96a599345858a90f847b76fac7d9c2ef95f38d5bb9b65b56d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6af08c0c655ba9bd6c074422bd2805552819aa850e60d682a58fa6d9283ce6d"
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