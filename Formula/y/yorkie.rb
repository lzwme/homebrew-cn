class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.15.tar.gz"
  sha256 "703004b671f9a894519e820d23a02dcfcecf1b729377474f454d898078385d53"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8cd35419c7290ed2d34765962a14d7d38bf7c26b87ea263e17e08740830ce97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8cd35419c7290ed2d34765962a14d7d38bf7c26b87ea263e17e08740830ce97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8cd35419c7290ed2d34765962a14d7d38bf7c26b87ea263e17e08740830ce97"
    sha256 cellar: :any_skip_relocation, sonoma:        "8297a8b217b743add0807ea085443862aba7e2f7a6b13a866eb3d111fa3a7316"
    sha256 cellar: :any_skip_relocation, ventura:       "8297a8b217b743add0807ea085443862aba7e2f7a6b13a866eb3d111fa3a7316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b37763515eb71707926e0602eaea5afb0a209202cd62d069bfa9bd361b271e0a"
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