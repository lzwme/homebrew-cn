class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.5.3.tar.gz"
  sha256 "9fd3e014bcea1f0c591fafbcf5b4121243821ad8424343537c17495e650d775e"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f4ac78f0a0fcaebda76a95a3b3ab0d8c44fb1e28d117652ae61d5b3f1033ff9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f4ac78f0a0fcaebda76a95a3b3ab0d8c44fb1e28d117652ae61d5b3f1033ff9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f4ac78f0a0fcaebda76a95a3b3ab0d8c44fb1e28d117652ae61d5b3f1033ff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "706eafe710cc615f686700cee73899ce24421dfbc35805aef113e53a30e48985"
    sha256 cellar: :any_skip_relocation, ventura:       "706eafe710cc615f686700cee73899ce24421dfbc35805aef113e53a30e48985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "991b7cd8762593cd0daaa4ef9dc2a8f8365fb063e9003f8c8906863d8be5feb6"
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
    yorkie_pid = fork do
      exec bin"yorkie", "server"
    end
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