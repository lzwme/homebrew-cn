class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "3eeae35f28f5d2f744c9034c85dc9a880f6798b39fcd118054ea0033d28c6fd8"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04a2907ae2974abe11603df3df581e3301de5a790a106350245843c546ffb07c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e6f8a499ec20ab6e6a255f641743fc9a466efd40868aca7fb755ccbcc3d931f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f8dcd732926efe399c69c8ee69e50989a747e5bd263f2df493cd5e866521c03"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8bb2dfa4a6164d856e9a8c3ece7a3654bcb732108e27ec058525f0fbe2686ce"
    sha256 cellar: :any_skip_relocation, ventura:       "1945e837e83205b9eb32f8195ce61a8e9095303ccfb3093cb167f3ed65eda4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4b361a82530bc2af55b70f96a0e50531d878116a65669a0b8236ad3437c7850"
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