class PythonPbr < Formula
  desc "Python Build Reasonableness"
  homepage "https://docs.openstack.org/pbr/latest/"
  url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
  sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "054b7472e390b7696eb6497484b2c74af8bbbaf34647ae1b685597e05e1841cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07209b05c8eed68f39f6d93dc6c0e883bed5a20300b03b5a0c208ad4cc4e427d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af8140d13662b44929161227c4cea3302f07882f9aa77ed687aa1160c5fe9b08"
    sha256 cellar: :any_skip_relocation, sonoma:         "235baac06589d1bd621a71768fd195f49693744ad134d288eebb2d566159b6b6"
    sha256 cellar: :any_skip_relocation, ventura:        "08d08193ce362049dddd37fc5fdd0ce93a5712bfb75d85d8e32c99369bd7c621"
    sha256 cellar: :any_skip_relocation, monterey:       "dfb722899a7f6e61cfd0d325b1d0d5c8bf22785885ec9f3d0575f7ee6a4e4efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb3ea9e739e56fb54a763888aa1c4b570d9e279952065e9d0b9bf2f9c7610825"
  end

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version)
  end

  def install
    # https://docs.openstack.org/pbr/latest/user/packagers.html
    ENV["SKIP_GIT_SDIST"] = "1"
    ENV["SKIP_GENERATE_AUTHORS"] = "1"
    ENV["SKIP_WRITE_GIT_CHANGELOG"] = "1"
    ENV["SKIP_GENERATE_RENO"] = "1"

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  def caveats
    <<~EOS
      To run `pbr`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    ENV["PBR_VERSION"] = version.to_s

    (testpath/"pyproject.toml").write <<~EOS
      [build-system]
      requires = ["pbr", "setuptools>=64.0.0"]
      build-backend = "pbr.build"
    EOS
    (testpath/"setup.cfg").write <<~EOS
      [metadata]
      name = test_package
      version = 0.1.0
    EOS
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyver = Language::Python.major_minor_version python_exe
      system python_exe, "-m", "pip", "install", *std_pip_args(prefix: testpath/pyver), "."
    end
  end
end