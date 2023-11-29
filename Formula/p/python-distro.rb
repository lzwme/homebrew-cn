class PythonDistro < Formula
  desc "Linux OS platform information API"
  homepage "https://distro.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
  sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2b6558e82268544f44cb4e8ab4a35956400bad7b5915dd4baed9d612dc8aec7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d136db2c7aa02bb743134aa0b9989204b17ddc835b4cecab843487df99ca33ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "219e0663b87a0a1275c40185d7ece0f86eb91242e94e9259b7d8c93c338a9367"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b3e5dd9a033110adcc4a45c228062aaddcac625f1a37c381a39be78aba33348"
    sha256 cellar: :any_skip_relocation, ventura:        "ee366670b4169fe1ae2f2d18675f85eda9b1514432b7cff567485b44c75e6cdf"
    sha256 cellar: :any_skip_relocation, monterey:       "a2467e733cfff971889b879aa8b1d8a1a29b77be17617663e725157084701555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffbf79ad0d283e7675894e819f5f901b8769a0b917fa12f8af79e405a9d1dc79"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  def caveats
    <<~EOS
      To run `distro`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import distro"
    end

    version_json = JSON.parse(shell_output("#{bin}/distro --json"))["version_parts"]
    assert_match "build_number", version_json.to_s
  end
end