class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "e8c10990e41f4e1a89fecfa5eb26a5ad555f904bbb08867171a05c5dd715c642"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42691f9815e0ce8e13e92b1094b7fd8f1ecee4c2282703316d6751e19c0e39b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7be6c5223437fc93f44776f78bce8404c3af156ae1f780e9a6174e337516a3db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dc56ed893591c8736ab66a605ea98a78f366738a059023598e25dde7898a550"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cec2ae87b56d9b1f0937f06fd548d371350c94e50db49adfd1aa819e70f5cb0"
    sha256 cellar: :any_skip_relocation, ventura:       "628892217a9f34991fd8e751f7987dd36a46e9dd73fa5c6d7571f3b75d9e5bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2248f7b16ac7ec5f69c546d5a1c77548c11a4ea266f44d6e9e6b3f54ca0975b"
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