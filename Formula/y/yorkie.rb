class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.4.tar.gz"
  sha256 "fd1ef86f79dc2652661bc684dddc7637700de09335e4f65149ac64420f7d2e2c"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50cd3bbe77c7ee645d4831f67c1abda3e3605e17819c50740739a4a41174bd92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50cd3bbe77c7ee645d4831f67c1abda3e3605e17819c50740739a4a41174bd92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50cd3bbe77c7ee645d4831f67c1abda3e3605e17819c50740739a4a41174bd92"
    sha256 cellar: :any_skip_relocation, sonoma:        "dce108fc32fc7dff423f534d08f3c54e12ac9e6b6550ad6809ee549b7e0d9410"
    sha256 cellar: :any_skip_relocation, ventura:       "dce108fc32fc7dff423f534d08f3c54e12ac9e6b6550ad6809ee549b7e0d9410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5abeabcc50cf89d35fb50c17cd96967484a9618e50de399cec0723d29f0b20fa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comyorkie-teamyorkieinternalversion.Version=#{version}
      -X github.comyorkie-teamyorkieinternalversion.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdyorkie"

    generate_completions_from_executable(bin"yorkie", "completion")
  end

  service do
    run opt_bin"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = spawn bin"yorkie", "server"
    # sleep to let yorkie get ready
    sleep 3
    system bin"yorkie", "login", "-u", "admin", "-p", "admin", "--insecure"

    test_project = "test"
    output = shell_output("#{bin}yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end