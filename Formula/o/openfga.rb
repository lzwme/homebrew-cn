class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghproxy.com/https://github.com/openfga/openfga/archive/refs/tags/v1.3.8.tar.gz"
  sha256 "7be621bdd601a608e8df7e510eeb18639066fd2418888be890519cf8ca8ac827"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ed4c0263acc98b6afabdc1b6bce42abcd501e867f92c516f38bf5e549f62428"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e53cbc0420d393f90fcd3163c34665d84d2bb8e87e485b204c25a284d790b65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cec6f4ecc32ee13b4426a59094995971685590e8e92165354c82faf5c46a30f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c9e4a6bd96ff4afdfda8d670e3a88be880d8c29d79af2a318dad8cdc4c63b06"
    sha256 cellar: :any_skip_relocation, ventura:        "412f3f54338a223b2d2002a1f543a233bda0d556a150da1b59a3697e4329de31"
    sha256 cellar: :any_skip_relocation, monterey:       "22f0fedc5b58019336cea7473a764be947027bb1b4d2017a8e9e380e4db14176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc7332f0aa5f7a36b27357f2bf6416fd39b9c8a46c6deaeceec5303d40426c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin/"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end