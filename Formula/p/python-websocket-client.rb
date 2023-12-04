class PythonWebsocketClient < Formula
  desc "WebSocket client for Python"
  homepage "https://websocket-client.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/20/07/2a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330/websocket-client-1.7.0.tar.gz"
  sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2ee36e9e239866be8f9e8be55e030e0d569fc080975b8ec17400ab4da65b728"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ad5cdb5ddacc0f44c52e70479c40d27706864699e0250f18769fb29dec0c920"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b84206bfb5b6447036b36b2a9548bb38d827b27daef6b9d6c0afcbe42a0f74ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8222d978814078b94b27cecb33e72310c32bb6d1d39a513fe279da7c626d9f2"
    sha256 cellar: :any_skip_relocation, ventura:        "b1d8d75ff0744e95be3a0eec75e3bd05630da6cdaeea8bc51f14bfd0c53b6a44"
    sha256 cellar: :any_skip_relocation, monterey:       "01420a929ca42eecebc77762f9c8ef2a669ec4ac9f4b2a8999f13c8bd6458fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e2f95beefb5b122edaba5fb95409ad0d77abeb4e92055b2605423b6263cf996"
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
      system python_exe, "-c", "import websocket"
    end
  end
end