class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "9cbe9ff88378c9ee6c504e92fc2c345a38da5e588475678a3dbf468144b23969"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "977fdf1e481b972f1b50806e84fe4d7c304a39778cb344272a1a9712850bef6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e09127e7a8723f0e7da06720c90b820ab6f87fb45a64e61b78a645a2ed5abd03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83950d6e0e56ceac7c0d0f5a0c28f7f1fe398208e517c1b4a479d937d613ce00"
    sha256 cellar: :any_skip_relocation, sonoma:        "5995b0b77e0794c6d384e6d293879573c1bf822c5ec8a2118d159a4d4441cfcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "595237afea389d46f2c9441ed3006d946aee357cf919600de2a01c6e6a7e505f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55178e5155b7c7a8557ed2567002df66657225feb1a60bec918cc67d70e24422"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", shell_parameter_format: :cobra)
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = spawn bin/"yorkie", "server"
    # sleep to let yorkie get ready
    sleep 3
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin", "--insecure"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end