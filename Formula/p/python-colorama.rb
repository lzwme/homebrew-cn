class PythonColorama < Formula
  desc "Cross-platform colored terminal text"
  homepage "https://github.com/tartley/colorama"
  url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
  sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "081228aca278c1825ad83052c63f428d06c3572775a4d4358e50eea0a50517a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb863e5d9f7d01365f6343ddb668e6ba736096ff76623934062c6fe357d24111"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d675e5bc288ebac0b2306a96c65b3c5891c67d63c127cd21fa0708cc561fc7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "84c26c388c33cf9241c2a5b580f8477395d5506035205ea02b88fbce554d1db9"
    sha256 cellar: :any_skip_relocation, ventura:        "9b73ab0980fd827c0f3fc03915b6bef1ebfce342a7a308ddfc13dc5f7d4bc85c"
    sha256 cellar: :any_skip_relocation, monterey:       "299b2e7ad1a3201aff9cb23ad5314ec8584d9abf7fd7363b6a667cbeab5f60f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16e9f0aa060430347035bbb01c19f61dbb65d3bea638efacd31b92cb3cec295a"
  end

  depends_on "python-hatchling" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    # no need to install tests files
    rm_rf "colorama/tests"

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import colorama"
    end
  end
end