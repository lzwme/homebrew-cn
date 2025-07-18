class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.20.tar.gz"
  sha256 "bd95b8f03f2f915a65a9a1af48c2f832703104893b90666e97a4c6cee35543af"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cd729c17a8bf03c699e63778ea666d05d175abe9402f20e60eb23ee34f92466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74dc4264c37aa6ccca90b8e0f8d22aeb6db1af503468c7645aaf9133798ebcb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cc16550dac0cabff81de4b0ac056f406fe316276cc28ba384e38b8e94e3c889"
    sha256 cellar: :any_skip_relocation, sonoma:        "177b90550d068cd3a9a611e1e2b7e0ab7ccf027a6eecda6e9c06570792ffc495"
    sha256 cellar: :any_skip_relocation, ventura:       "ba680dc8c2155c5560bc54acd7ca8dfe5c05524e524baed82079f1444915a543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9f4e5472b5b7f76827e4986e28934189829fc9cba95e2824425a2026e00ccea"
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