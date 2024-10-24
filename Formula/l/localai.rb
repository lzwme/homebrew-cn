class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https:localai.io"
  url "https:github.commudlerLocalAIarchiverefstagsv2.21.1.tar.gz"
  sha256 "11526b3e582c464f6796fd8db959d4ee64f401b2f8eee461562aa193e951e448"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "c4bb8af9aaf37487babcab1492476d58bbe7a2b9ad35b72ed4f55ffa13003e14"
    sha256 arm64_sonoma:  "03f32aa33e9e5b7b49a26b46ff3fada2a1e3be5dca70350e98678f0e5d68bd6b"
    sha256 arm64_ventura: "6690dfe78d6bb085649e0735d0c42e83a7ad9d7d7f38a7a5f4cdcce0ab7dedfb"
    sha256 sonoma:        "d4c7249263f81740b721f1faf1cb02078ffda35b6e50bf2ba466354d05e81591"
    sha256 ventura:       "e8ece394e3ddc7b931286785a9b8be520872e7a300c7b84f610e64303e6758fd"
    sha256 x86_64_linux:  "1186c9912454b1530b1261d8b84fdc2bcd66873f0f9d5c9f0cb2c25ae8a992dc"
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
    url "https:files.pythonhosted.orgpackages9f30cd31c3a04814eb880d5e78cea768240c92fb5adaa158814c2b166356a0c6grpcio_tools-1.64.0.tar.gz"
    sha256 "fa4c47897a0ddb78204456d002923294724e1b7fc87f0745528727383c2260ad"
  end

  def install
    ENV["PYTHON"] = python3 = which("python3.12")

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