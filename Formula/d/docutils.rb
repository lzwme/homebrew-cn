class Docutils < Formula
  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.20.1/docutils-0.20.1.tar.gz"
  sha256 "f08a4e276c3a1583a86dce3e34aba3fe04d02bba2dd51ed16106244e8a923e3b"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d4fef7ea86f0305f6a482f772d7d988bc8d077b1a613f8c74d559dbecf70b4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f444a95c5321e31b105c21afc12c16be8c7b65c7c4cf28f861fecb069bb6fbb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32fd4f9936118b027e3a834cc54fdc31f9bd7d9d3b675fac4b2f5cb06e5a7023"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee09a72453890700d748f071ef0a6138e91d694b2657e0199b1a0d808186564a"
    sha256 cellar: :any_skip_relocation, ventura:        "1f9cf57be4ce59ca4055cc2bdc28a8c8b0ce52e4b524b94a3d0ed13882270dcc"
    sha256 cellar: :any_skip_relocation, monterey:       "b6da8716b7095b5060e6595751df1f6f865d821790e31d0467e68f732ea4d109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a90a2509497e5265edf387688b6351cca65a1a66b6d1d5b1053b925bbcf2d807"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version)
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end

    bin.glob("*.py") do |f|
      bin.install_symlink f => f.basename(".py")
    end
  end

  def caveats
    <<~EOS
      To run front-end tools, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    cp prefix/"README.txt", testpath
    mkdir_p testpath/"docs"
    touch testpath/"docs"/"header0.txt"
    system bin/"rst2man.py", testpath/"README.txt"
    system bin/"rst2man", testpath/"README.txt"
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import docutils"
    end
  end
end