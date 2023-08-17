class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.8.3",
      revision: "1eaa6376b9ecb7d680568d99a8690e3a0a665721"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80987b653015b84e7bc5c4409e4a2a11a11d95f4b1a9d2216886fbc6fff7d297"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11741147a9870ad04e923676f4e9eef485df44cb30c1bd13008db1db277ec2b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e28661514b9931b4485e711bc33df0f4d581270cbc1bbb1d51e9baa842877b38"
    sha256 cellar: :any_skip_relocation, ventura:        "98422b810525dfa81022d110c69ba51a86639f987ae6f89d156bf813e8ccd07e"
    sha256 cellar: :any_skip_relocation, monterey:       "d85331f789cd64516b8c64aaab94d6b04c3fbf72fc986df1a09bbdfbba15101c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b19cb9b00fc46dcf8bbf35bc1f41809d616bc7581193625959b4cd21c4741346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bfee86f97221b6fe08ccc95c16cc4d153400f07472617d9706e0f312e385ede"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end