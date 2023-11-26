class PythonWebsocketClient < Formula
  desc "WebSocket client for Python"
  homepage "https://websocket-client.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/cb/eb/19eadbb717ef032749853ef5eb1c28e9ca974711e28bccd4815913ba5546/websocket-client-1.6.4.tar.gz"
  sha256 "b3324019b3c28572086c4a319f91d1dcd44e6e11cd340232978c684a7650d0df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f36812e650dc39270024e8d5114fea813bb2cb9f564f55dd876664ce79b1a4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d9ae103fecc0dab8050cf133f3cfedbcb1b2f01360fadb806e7c111cf59d01c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f47b37f1585f561dbdfe05b06bd3fcc79cc108392c95895584b2ef6904264f7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c879f52122b9f4340f00583643b88bdd566a07a61333ce631d7a468408daf14"
    sha256 cellar: :any_skip_relocation, ventura:        "cc9926863b43ae39d562eb1ffdb591554367b0ffd768a64c3015e091d8827390"
    sha256 cellar: :any_skip_relocation, monterey:       "120c645d3269eb0529df05be525498332a96900f0852196c11056aaa6cc93cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e13ba8a7a568066f09a1a28258f7ac6ebb8849249f5c1e4972ed1e530f25f8d"
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