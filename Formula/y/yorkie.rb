class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.42.tar.gz"
  sha256 "7446ad0ffbc08779d5033f968eabe6a93aa4bba9b6fd2942c7585100cf20c841"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8de4f6533b10538884a421e3e2958e2a2d40687956603948cd597d4235e98598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7300ca0770dd45f9ca0653b91d4cdbbb12f075837e7c469be5be019bc03d7aeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7296630b6a86400b5bbb51672a7a5d4842dcce5737c63cb064ac7d38f601f5e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6ffa0efcf3896ae5f63e24e11778c47ce874809a8267f20c50f5c344829a949"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22bd9eebd3c56856fae884a7912b8d376451be7944a3cacdc2087e2758ff4640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0bfab98b50e70bd517b2eb9f0678581c369573ecdce689cf58c6977ee4b8e11"
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