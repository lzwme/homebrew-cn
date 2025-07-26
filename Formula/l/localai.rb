class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "9bdf68d1da47fd3b40d30e433b2be92343b20f8dd8f239631a0b0afc67dee45c"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aceb97fce888c38c29bc3a5c4b0856ce0995901156c07e6bfb530c6de7062fd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "116dd0badd8dd8a0bd6a52db203aeb326b473af6fa58aedfe4be3b535b0446dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb389339a9ce14a345b07244b3a81d21e900ed6b3013bd8dd10c091cb8409955"
    sha256 cellar: :any_skip_relocation, sonoma:        "b092dd23cdafde3b2caa6f093b490f44fafbc2a9090a29318ac17253e6f461bf"
    sha256 cellar: :any_skip_relocation, ventura:       "63f12d1e03fcb11d36997fd98ebb6da29b312b9c2fd3bda97c28687dabf0c0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e438e805b4fc6b9606455171f8915a4e14f84cea959de812c2302b4e9b93f3cd"
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