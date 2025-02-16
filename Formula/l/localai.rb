class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https:localai.io"
  url "https:github.commudlerLocalAIarchiverefstagsv2.26.0.tar.gz"
  sha256 "9cdafd1aa157dbc1fa14cbe62b9d5c0e94422172d48c9fc424131916ad10a7b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beefef3660c05f418321f60e7157d2ea8ebdecce71355e37754e823ae66fb787"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3d81153835ec2683a2853e482503fd9a3dfdf8f4c365266820dec596fca46e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad1d15a333d5f3906d8bb8e5afb9ff9dcf2ce563024328f5c371cdbc90e5a54c"
    sha256 cellar: :any_skip_relocation, sonoma:        "59d02fc81cfa530869a0587449d376feaba752a58e912fb16e196643de6fac0b"
    sha256 cellar: :any_skip_relocation, ventura:       "fc70aea23b8e998d06ea8ab06e028ee0f95f9a0d16d9f53dec5a7a0427781e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f48ca2dff458a789804fec3c8a9068a7cd3f966352448028041f278c831011d"
  end

  depends_on "abseil" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "grpc" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build
  depends_on "python@3.13" => :build

  resource "grpcio-tools" do
    url "https:files.pythonhosted.orgpackagesc1fe3adf1035c1f9e9243516530beae67e197f2acc17562ec75f03a0ba77fc55grpcio_tools-1.70.0.tar.gz"
    sha256 "e578fee7c1c213c8e471750d92631d00f178a15479fb2cb3b939a07fc125ccd3"
  end

  def python3
    which("python3.13")
  end

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    venv = virtualenv_create(buildpath"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root"bin"

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    spawn bin"local-ai", "run", "--address", addr
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    response = shell_output("curl -s -i #{addr}")
    assert_match "HTTP1.1 200 OK", response
  end
end