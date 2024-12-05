class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https:localai.io"
  url "https:github.commudlerLocalAIarchiverefstagsv2.24.0.tar.gz"
  sha256 "cdb23d725937c1e836a11b98761abc10cc28dc1e3c7ccc1d0c7c719dad3b7097"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "bc9c2465d7d3ba3db032c726ba11212a8d4900672f5fda0cd26408020356dfdb"
    sha256 arm64_sonoma:  "6f74c163eed4cb1cd441ec23e2e9567d82745973d8772ac7b68ccdf3966bee58"
    sha256 arm64_ventura: "7681066e72cda6c42cb502840d0a657a19e77e2d9110696855a105a6b651ce9f"
    sha256 sonoma:        "253cb8990a2d020ab3a3767dfd4a5fe716be6a2eb4c4cfa65c61edcd33326c18"
    sha256 ventura:       "fd26ce3dc9b5895c85c1e5c1438a3a147f55acc6a7c7ce9dcb9b2912b2899b3b"
    sha256 x86_64_linux:  "75993324ed02c9ae2808371c5243e5c1088a763dfc261529e8771964ccd7f4da"
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