class PythonUrllib3 < Formula
  desc "HTTP library with thread-safe connection pooling, file post, and more"
  homepage "https://urllib3.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
  sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68ca7b2595d00a172262bcd3cb84750a13d8744afdd516fd12fe52388331c5ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1d771f229cf123762d5a8a1ae412e1698f00f19f3cf8a7be7942875becd21cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "612a5fa6e124a4756f38285bb3d53e809a94a12d8cf70eafd4a145abe5449fc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3722e06eb647e93264f72740d61f1d9c5f89a79324a9f01a90be2fc34b10a8c9"
    sha256 cellar: :any_skip_relocation, ventura:        "527da5bce8db6b55f0f45711f105e00e452674f86d1f027922b24db7ecbdef95"
    sha256 cellar: :any_skip_relocation, monterey:       "0472514ffb77ff537a5302a05f78911e3aa9db2abcc24800066ccabacbc4c577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8107f632b11ce28b365879a94bcdd3e1c23cc0180550d9afb2cb8e090906b82"
  end

  depends_on "python-hatchling" => :build
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

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import urllib3"
    end
  end
end