class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "5d3a2c8dea67eb5b928513a34b58f782c51efbd72373396f15ef78555015171b"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26244d55e8152ef8af0605c6d0ee6e1c2b0067ad323fd4b34133cdea1e11d437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26244d55e8152ef8af0605c6d0ee6e1c2b0067ad323fd4b34133cdea1e11d437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26244d55e8152ef8af0605c6d0ee6e1c2b0067ad323fd4b34133cdea1e11d437"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b17043e9a12700a6c892e8781827bc586ec377dfddece6f014bcb9484861b78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4a94f7f2178a276d5007ceefb97bcd0c645424a57e1f296dca9fc7b1174fb95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cc3e08f0797185eae853c60d07e699ec8a4e47b3889886c75e7599325140338"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end