class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "fbdd8ad335d47ff0a079bf078334ebd22646c630be4a34fe8547ff6d138a9476"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fc7e7d970ca0f0381e0392f369721d921aca0462baacf455aaf2e5bc7081f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8de58ab0a9cfa4773d97b6575ad37d77b6cacf7377bc6e6d39ca209ac77e0ec6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e52d86702fd4d037ec01be4e012a04cb6b23b7d60f45b67499f438467d51f485"
    sha256 cellar: :any_skip_relocation, sonoma:        "21e2e5db24b6be604f7cc2ae4e169815a477b8dbf6ac6e7e16a2d291c4a4fc32"
    sha256 cellar: :any_skip_relocation, ventura:       "a5f061466cfaf48c6e57c503557875d40c68226c5686d3080ef25468bef37a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55401c7ffcb7fc2f9b82ce8e46c7bc2d78c6a7516faf8096fd10ebbea7d3ebfb"
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