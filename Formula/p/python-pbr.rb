class PythonPbr < Formula
  desc "Python Build Reasonableness"
  homepage "https://docs.openstack.org/pbr/latest/"
  url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
  sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec50639a6856bcbed7ad5f34baa7e2ed70d87ceacec464e5709b845cb32459e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09f70851b62f61a9aceb3d1e7f7f2ea9ead8dae3b4f05064ac2e6168f06e919a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8aa17f55dedaff5e5ed6888542438d02df1f586bb2d1879eac22e23ef790984e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f470d34cab75d1ee824f33ee7441ca5553ed740b7942b9908ec0e726fa5a4663"
    sha256 cellar: :any_skip_relocation, ventura:        "a887394fc2ebb50247b7fdfb9d76c539d020e8f6e2b81ee401c5b4e22fb76e08"
    sha256 cellar: :any_skip_relocation, monterey:       "ba7f696a5fa9efb25199a5dacc0030a0b2247f4eb2bf26f14c2cbc5cfbf0b505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53affcca5c74a206b1efbdff00aaf42c14ab55afedddb0acae479b0c07b2bba1"
  end

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    # https://docs.openstack.org/pbr/latest/user/packagers.html
    ENV["SKIP_GIT_SDIST"] = "1"
    ENV["SKIP_GENERATE_AUTHORS"] = "1"
    ENV["SKIP_WRITE_GIT_CHANGELOG"] = "1"
    ENV["SKIP_GENERATE_RENO"] = "1"

    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
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
      pyver = Language::Python.major_minor_version python
      system python, "-m", "pip", "install", *std_pip_args(prefix: testpath/pyver), "."
    end
  end
end