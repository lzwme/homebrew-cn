class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.26.tar.gz"
  sha256 "3fa312c17593a5974caeeb1900aa7d6133e55bfa249da3135f79978b723a3550"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d368c21b3879a92a64b8df28a9ec1c42f08568cd377966a36fb69762c9e4cdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f16d3e5ea43796bc933810803ae02978cf6ad61ddb415d2852e3c07b9ed6bf87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cec967c60384fffc783c2f7ab1744a2b523c4898ea931366b0723d7893a0ad36"
    sha256 cellar: :any_skip_relocation, sonoma:        "4be620065102d844ae6b6228afcdd81ec482bc4248977b7106ed8776b9bf93cc"
    sha256 cellar: :any_skip_relocation, ventura:       "64c52d7b1a2a397d456d7eb97b30b488ae7aaa0264d0d8d12a0675ac504bccb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9ea42d87c5f2c55d5e1f5dbbd25b13181abbbf3b836273cef8be9e37f7bcb6d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", "completion")
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