class Lit < Formula
  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/98/a5/f3d49178d1e69224d8680b0a0a02d42d221b45e703587bb2339a0503f421/lit-17.0.5.tar.gz"
  sha256 "696199a629c73712a5bebda533729ea2c7e4c798bcfc38d9cd1375aa668ced98"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "567dc79c15353450bf1ddfe468032a870c56fb6ea8807552747cce5ebd3ce3e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8fe3e7e73e5c254ca9b953cb3f47180526f2fe5898faf16aecdcc968ca53906"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "277b30d1ba5724e471b93968c10063192c8a242fa93bd291282b682a25eb2165"
    sha256 cellar: :any_skip_relocation, sonoma:         "15fff58769989d66e3c4f668733655fc2713e666e7ace3852a2102780ceab79c"
    sha256 cellar: :any_skip_relocation, ventura:        "d12672032bc1de3f7f302c9349c8c8cf65e6306f41dbba57bf78176cd2034781"
    sha256 cellar: :any_skip_relocation, monterey:       "f3e4f3ff49c706ab44c22466f8f4724a9d5a530368c4265cdba84a4b67447715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e279a6f038209e8b3cef565294da40b2e46079bd0c8e8687c387c6ddeb5126a5"
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