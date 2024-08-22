class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.4.31.tar.gz"
  sha256 "6b9e6210c677dd6ffb88c762e6e65fd0acf21a4f324ed6859e33a83b3ed8e886"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e7cbd811da600ec38939d6a60c19e6f2a9fa563f5746e643322098d15f871b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e7cbd811da600ec38939d6a60c19e6f2a9fa563f5746e643322098d15f871b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e7cbd811da600ec38939d6a60c19e6f2a9fa563f5746e643322098d15f871b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "117829a6a2aefb210388fc170fe219217396870bfaa123b15f7cd8ba065397dc"
    sha256 cellar: :any_skip_relocation, ventura:        "117829a6a2aefb210388fc170fe219217396870bfaa123b15f7cd8ba065397dc"
    sha256 cellar: :any_skip_relocation, monterey:       "117829a6a2aefb210388fc170fe219217396870bfaa123b15f7cd8ba065397dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7753d24957b98b100727ac839af1b81936824410702e23eba17b6695642bd554"
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