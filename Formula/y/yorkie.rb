class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.24.tar.gz"
  sha256 "4b59cda1985172a68bcb968035fcb6bcf684cd1cf9b5da4a32a81740d3f8066f"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a08ec8d6c930cc78a1e6fbc8dfa7b5e0f56840b20b1c76c29e91ab9ab7ece19a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5847da744d168f71148a75662819cc4afd35b004f0e84851ab950ef41404e203"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b62f683fbe29d997d247c3652dc4f3eebcf4e3512a1fc73b4fa8cd13fc7fdbd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5f2e23d772b9945e5e2c975cdaf81bcb00564ab48d00be9ee663a2f9121b560"
    sha256 cellar: :any_skip_relocation, ventura:       "1b4981da17c175eb0ef94fb188537012b76b7e3bda92b2336bf15a2e0d001cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9829f17a68a7825f2f6d99a7dbbe001480e95f8274ff4e7bb3521bf414a3c5ec"
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