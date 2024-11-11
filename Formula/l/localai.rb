class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https:localai.io"
  url "https:github.commudlerLocalAIarchiverefstagsv2.23.0.tar.gz"
  sha256 "45dce2745e15debce36f2faeddb1b2688f6e6f9fce80ff204b2463d234d14686"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "3a69527cb12060b36a6eb44c70c902a46112b41b6181d9df2c426125684c5c20"
    sha256 arm64_sonoma:  "e8adcd0dd78e95ea39e2323534606ae9746839edeca4f22cf2d4f5eb0bb895ca"
    sha256 arm64_ventura: "4c7775202e25e4e81141fb3fde595203ec0d22d011d3bef0501a12b4cc1fc7f1"
    sha256 sonoma:        "e4d7ea2f2d9df99a9a6efbcd7f7a86035f0eda0a99c0894d5ff6c1bab4cdaaf6"
    sha256 ventura:       "09dfcdd268edc7e7b69e465a331aff6e1579d6ba274d41355a091445fc20a560"
    sha256 x86_64_linux:  "75a31b74573ed7e2c851dced6367031029e09168d48703b138ac5d4c0276e229"
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
    url "https:files.pythonhosted.orgpackagese7f862e15867651b72f6f95313e21d81f5f1c210b69a4cc664aecf52ec4c8a53grpcio_tools-1.67.0.tar.gz"
    sha256 "181b3d4e61b83142c182ec366f3079b0023509743986e54c9465ca38cac255f8"
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