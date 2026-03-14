class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "16a8e64d504be66c849061e412fa6a386dc32d2b6c9ff964db17671e134b7b1c"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca09af8fccae1631532ca43b6d262f00879918c6e928fed8bccef827137e853f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0cfb1ad6b6c527ce60efa105f430a13682255991d9de41090109cf1b194c8ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "999c5d1de252e09b945f698a1af78810e149e90b96932c9e5a18d3937e0f9380"
    sha256 cellar: :any_skip_relocation, sonoma:        "894e77d3f0b92976fd0dce0750f940bca7a5b914b1b5b32727ef937ab1fdd152"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a2e78d92d8af673cf5769157e6b7d3a4abb65e40ce90b9f61068d775a6fae55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8074437a2970b85ac8f3944ae3debde6cd21d04d2d2e0a2e2c95ecb165c6dd6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=#{tap.user}
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    pid = spawn bin/"openfga", "run", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end