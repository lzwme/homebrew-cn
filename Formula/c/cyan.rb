class Cyan < Formula
  include Language::Python::Virtualenv

  desc "iOS app injector and modifier"
  homepage "https://github.com/asdfzxcvbn/pyzule-rw"
  url "https://ghfast.top/https://github.com/asdfzxcvbn/pyzule-rw/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "fa2ce2a9a715ef9691f77a293ad58a61a6daf170896aebf32024c0ee797fc4a4"
  license "Unlicense"
  revision 1
  head "https://github.com/asdfzxcvbn/pyzule-rw.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "207ab362ff1d7cdc407a325362dd38ca9d9ff1162ca47d5df73f41e5c5191577"
    sha256 cellar: :any, arm64_tahoe:       "e329832402b95e031ccf71cf7158cf747f90701ec36ded36a24fcec6f30e3fd7"
    sha256 cellar: :any, arm64_sequoia:     "9f42456f4e01b317bde3261ec215cc826d472f92f02714d35ab605b516b4d47e"
    sha256 cellar: :any, arm64_linux:       "729374ebe9c37e811bbed2e1887930dcf20528933fbcf9e2e9b086e13fb2c79d"
    sha256 cellar: :any, x86_64_linux:      "e869bc11fbd097a0653e597f1aee40d728582193555876355bb1dcf8dfdbb352"
  end

  depends_on "cmake" => :build # for lief
  depends_on "ninja" => :build # for lief
  depends_on "rust" => :build # for lief
  depends_on "ldid-procursus"
  depends_on "python@3.14"

  on_linux do
    depends_on "llvm"
  end

  resource "lief" do
    url "https://ghfast.top/https://github.com/lief-project/LIEF/archive/refs/tags/1.0.0.tar.gz"
    sha256 "2cf412695ff739d82e129db441e5c2025f3bb4873a3d3a1d3dd4cf300b682abd"

    livecheck do
      url :url
    end
  end

  def install
    venv = virtualenv_install_with_resources without: "lief"

    # https://lief.re/doc/latest/compilation.html#python-bindings
    resource("lief").stage do
      venv.pip_install Pathname.pwd/"api/python"
    end

    # Keep only tool binaries for the current OS/architecture pair.
    tools_arch = (!OS.mac? && Hardware::CPU.arm64?) ? "aarch64" : Hardware::CPU.arch.to_s
    tools_root = venv.site_packages/"cyan/tools"
    tools_os_dir = tools_root/OS.kernel_name
    tools_dir = tools_os_dir/tools_arch
    rm_r(tools_root.children.select(&:directory?) - [tools_os_dir])
    rm_r(tools_os_dir.children.select(&:directory?) - [tools_dir])

    # Replace prebuilt binaries
    tools_dir.each_child do |tool|
      cmd = tool.basename.to_s
      rm(tool)
      next if cmd == "insert_dylib" # has no license so fall back to LIEF

      replacement = if cmd == "ldid"
        formula_opt_bin("ldid-procursus")/cmd
      elsif OS.linux?
        formula_opt_bin("llvm")/"llvm-#{cmd.tr("_", "-")}"
      else
        DevelopmentTools.locate(cmd)
      end
      odie "Unable to find replacement for prebuilt #{cmd}!" if replacement.blank? || !replacement.exist?
      ln_s replacement.relative_path_from(tools_dir), tools_dir/cmd
    end
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/cyan --version")

    # Generate a .cyan configuration file and verify it's a valid zip
    system bin/"cgen", "-o", testpath/"test.cyan", "-n", "TestApp", "-v", "1.0"
    assert_path_exists testpath/"test.cyan"
    assert_match "config.json", shell_output("zipinfo -1 #{testpath}/test.cyan")
  end
end