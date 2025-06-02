class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https:logdy.dev"
  url "https:github.comlogdyhqlogdy-corearchiverefstagsv0.17.0.tar.gz"
  sha256 "2de95d51912a9cc88e49b309735e5946082e498e20af71c5f42bbd416e09635a"
  license "Apache-2.0"
  head "https:github.comlogdyhqlogdy-core.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44c71c2408d41cd551f14112ad6001b2237d6ed04afd76963e6414ad84ff6d27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44c71c2408d41cd551f14112ad6001b2237d6ed04afd76963e6414ad84ff6d27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44c71c2408d41cd551f14112ad6001b2237d6ed04afd76963e6414ad84ff6d27"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cbf8423a12870ffff21d6f88defc4f6ca59e7cf0994182003e08ad653499d6c"
    sha256 cellar: :any_skip_relocation, ventura:       "1cbf8423a12870ffff21d6f88defc4f6ca59e7cf0994182003e08ad653499d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3135fa76591aaf207651163fa26f2f1b96015861af9fcf38c2ea9e892140f26"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"logdy", "completion")
  end

  test do
    port = free_port
    r, _, pid = PTY.spawn("#{bin}logdy stdin --port=#{port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end