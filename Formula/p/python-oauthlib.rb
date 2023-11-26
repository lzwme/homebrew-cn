class PythonOauthlib < Formula
  desc "Python Framework for OAuth1 & OAuth2"
  homepage "https://oauthlib.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
  sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db30557b5c6282022d6a5c957230240e669dc44db79d72a8eb5873137db0772e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e72e512293d89ea112a4a3c70a9f7993e3edb136394fa11965331c2ab5630382"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67ce8cf48c2d21a4e174a5ec57db8afcdfc51cdac72f94eb4fca8af9e9dacdda"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d792670a6291d51ec46efbd5c29fabcba53117104ee34f7146c5e21cb96eeb6"
    sha256 cellar: :any_skip_relocation, ventura:        "eb4f4b7aaf50b1fa3233b601159e1aeffd62d45612448f9faf4b001346d605bc"
    sha256 cellar: :any_skip_relocation, monterey:       "3873f047de595a57d1dc986a5ab2adbea669e31ef46560deeef678b2a080955c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a8d6833ad1b02d24578558668f097553ea3c915dc04894898b4cc114b64caa0"
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

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from oauthlib import oauth1, oauth2"
    end
  end
end