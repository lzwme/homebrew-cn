class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://ghfast.top/https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.9.tar.gz"
  sha256 "5ccf3b00e50c655e3a8a625224685f514eefdc4cc626f2040f1831b29ebe8fa2"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77ae01e9d558eab1917b22616bd6a2e3f1ee64a2f855d3620f07ec1f35833c6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96faf982331a4ea18fa81c8017a0a5eba9b30b91cfb286de0c75629e56c6da95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22120dad07aabdf10f9f8a6c8e265767c75707ffdc5ae0c9eb5390e0ad4261ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "4534b135e5b7a48fb7221dddcf4d38bb325378e7e131b742a2ed8bbbe6c74c3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a817f544eafd894894e2ecd9e7f79d76603533d05f7f94886bb97126c84bbba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab1b686db4caa839ca642231ab42090d2792fd0deaa516c0fb3133adb83eb1da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "aws", output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~YAML
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    YAML

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end