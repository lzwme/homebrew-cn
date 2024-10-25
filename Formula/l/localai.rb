class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https:localai.io"
  url "https:github.commudlerLocalAIarchiverefstagsv2.22.1.tar.gz"
  sha256 "154c32325bd1edf5fc08fdcd85c337ab6615393e2834c896fb27dbeb13e52322"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "ffdd5911e143ab06159a314cc5789a102939f6697378960c4c2a78fba30d0dbe"
    sha256 arm64_sonoma:  "19040a814fed943c66858fbfcdef70552fbefc089526acb60cc74c818a42ed88"
    sha256 arm64_ventura: "5c57dbb1d94222cd2baec49ba0ded1cce004fc4767a1dbaba9a6df02a6b3f493"
    sha256 sonoma:        "2e8e0b7c31304982aace3ca9d3ebeaabdd2b5721156472505830c57c3038db1d"
    sha256 ventura:       "3923840bffb0c62e74015a50087048990d3bbfcdf1ccd9a2bda6a61fa6a5b8a5"
    sha256 x86_64_linux:  "c362c41adf070c84e7feed970f7c619f55a0e87262c9016be945e7ae9ba0104b"
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