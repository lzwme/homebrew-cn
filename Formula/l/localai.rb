class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "efc1f805e9acc1a9fbd29801e69e307de1f767671dd280a4909297c74f5e6178"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ac3c818791d46b26b8b767a10fc91a93d28589fe32375f8e5b95746bdf34dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7702f845481990e5810cf4344c54c693e84deec23e220c388e95c67deaba41a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebc58dfe070a6875e813c831bf1ba58f2a1e0f53a0d0e87119110f1d536c023a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff1acf4613e171e5ba3cd1003752724394da093a85d512d89ee6b0071ac528d0"
    sha256 cellar: :any_skip_relocation, ventura:       "8dee14885a3fb05f754fff9a453cf19717e3918099f1fc653692efabd5f228b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4843b29868c9b28453b08396898c6bb8e56775f2d90c2f9748bef94bcf19256"
  end

  depends_on "abseil" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "go-rice" => :build
  depends_on "grpc" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build
  depends_on "python@3.13" => :build

  resource "grpcio-tools" do
    url "https://files.pythonhosted.org/packages/90/c8/bca79cb8c14bb63027831039919c801db9f593c7504c09433934f5dff6a4/grpcio_tools-1.74.0.tar.gz"
    sha256 "88ab9eb18b6ac1b4872add6b394073bd8d44eee7c32e4dc60a022e25ffaffb95"
  end

  def python3
    which("python3.13")
  end

  def install
    # Fix to CMake Error at encodec.cpp/ggml/CMakeLists.txt:1 (cmake_minimum_required):
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    response = shell_output("curl -s -i #{addr}")
    assert_match "HTTP/1.1 200 OK", response
  end
end