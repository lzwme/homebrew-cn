class Lit < Formula
  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/20/87/98366aa460de9a1413a41178acb9f83de106208f889fdccf47c5322163ed/lit-18.1.6.tar.gz"
  sha256 "70878fb0a2eee81c95898ed59605b0ee5e41565f8fd382322bca769a2bc3d4e5"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d983e553dc1c1bbb3e64f3af25f44376e345fec3d3aa81a08020ddba9aef021"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "137cf94ac4198141245b3046eeb6a2fc70fbcda9641504c664a6387709f779f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47ccb91d393ea43601c1731e8fee2b1af589c431c016a4e01d2e7857f008f119"
    sha256 cellar: :any_skip_relocation, sonoma:         "68034023f453f37c0ad8f394b409d1acdd77fba78191f24a0dafb34c52ac3088"
    sha256 cellar: :any_skip_relocation, ventura:        "9219644b74ee94aec25a44ff52a917477f3d85ea2a3df057d2ad592faa366825"
    sha256 cellar: :any_skip_relocation, monterey:       "7cd284c6cefd09a1aae7017be35651529572bd262f1a42bb652fc777085483ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "272675caea165b67c8c26b12c6456eccc4f3cbb2e863d127872f88ddbba6e03b"
  end

  depends_on "python-setuptools" => :build
  depends_on "llvm" => :test
  depends_on "python@3.12"

  def python3
    which("python3.12")
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