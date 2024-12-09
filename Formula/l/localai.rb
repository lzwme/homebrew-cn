class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https:localai.io"
  url "https:github.commudlerLocalAIarchiverefstagsv2.24.1.tar.gz"
  sha256 "a385b8e4ecea2aa441c9295d97c02551fd0534cd2baae294381c9bb4c03bc1ef"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "dbde25f7723af4a74b3be3eed6859eb74512a315501c8aa19a5760bdf10c8d19"
    sha256 arm64_sonoma:  "7fdb9e2d88d100fa2ef381d0418d4385f825c00dbf960af60febb0d425721597"
    sha256 arm64_ventura: "6eacc12749fcc4cb4bc22497fff7fb9b289d2dc5ba82f1f834da23295e98665b"
    sha256 sonoma:        "06a41be7636b0e832a29441c5891fdc6eacae13115a470c1a76dc8d305af753a"
    sha256 ventura:       "d527f52778e973b3c50a5094434bc0870a6aec6b700ddae29720d3157c565159"
    sha256 x86_64_linux:  "7e16c298d592ccc6a7c9d4b32a21ebdc7d0e5f7c3060f44d7ba0ebc506afe274"
  end

  depends_on "abseil" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "python-setuptools" => :build
  depends_on xcode: :build

  depends_on "grpc"
  depends_on "protobuf"
  depends_on "protoc-gen-go"
  depends_on "protoc-gen-go-grpc"
  depends_on "python@3.12"
  depends_on "wget"

  resource "grpcio-tools" do
    url "https:files.pythonhosted.orgpackages2a2fd2fc30b79d892050a3c40ef8d17d602f4c6eced066d584621c7bbf195b0egrpcio_tools-1.68.1.tar.gz"
    sha256 "2413a17ad16c9c821b36e4a67fc64c37b9e4636ab1c3a07778018801378739ba"
  end

  def python3
    which("python3.12")
  end

  def install
    ENV["PYTHON"] = python3

    venv = virtualenv_create(libexec, python3)
    venv.pip_install(resources, build_isolation: false)

    system "make", "build"
    bin.install "local-ai"
  end

  test do
    http_port = free_port
    fork do
      mkdir_p "#{testpath}configuration"
      ENV["LOCALAI_ADDRESS"] = "127.0.0.1:#{http_port}"
      exec bin"local-ai"
    end
    sleep 30

    response = shell_output("curl -s -i 127.0.0.1:#{http_port}")
    assert_match "HTTP1.1 200 OK", response
  end
end