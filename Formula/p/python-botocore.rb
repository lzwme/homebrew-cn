class PythonBotocore < Formula
  desc "Low-level, data-driven core of boto 3"
  homepage "https://botocore.amazonaws.com/v1/documentation/api/latest/index.html"
  url "https://files.pythonhosted.org/packages/1a/46/06e9194e52bc3598225944152710829c27d257ad0cc6144d408f10840868/botocore-1.33.0.tar.gz"
  sha256 "e35526421fe8ee180b6aed3102929594aa51e4d60e3f29366a603707c37c0d52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f19611327e46d99615c342efe3e9f5b2483a0c38b80a41598fa87366da1bb576"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96ab5a4f04bc15a00f3a53994273beeb108ed4a9fbe0010218936061a7f079b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "505ff4ead10d26bded1b7dd8f43d18771e6e2f2c6bd2adc1e971edebc35917c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa142f1e11fdb06c8205cf86c789ffedbf9a4da7f4c2cd2e5ef204479bdf6264"
    sha256 cellar: :any_skip_relocation, ventura:        "eb0b4adfde657878215ff798382e468f87fa32edda2422d82abb256d37cc2382"
    sha256 cellar: :any_skip_relocation, monterey:       "01da031fddb8b3fa2f0a41b7c7a426ae1945af04880ca79ab79b6acdfefa23f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ca63dc885a9c3076fa0af5c35d5e656653b0a1f5e22cfc41213d22268d1061e"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-dateutil"
  depends_on "python-jmespath"
  depends_on "python-urllib3"
  depends_on "six"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from botocore.config import Config"
    end
  end
end