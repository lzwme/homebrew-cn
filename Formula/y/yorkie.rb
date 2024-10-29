class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.5.4.tar.gz"
  sha256 "1d7fab9134ad5fade6c9480ae7830b30f0c523d5d5e8e45200c61845965f3eaa"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fd66faed4ec2e2190e3eca41c70a060993d736224b610666fefec5a044cfcc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fd66faed4ec2e2190e3eca41c70a060993d736224b610666fefec5a044cfcc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fd66faed4ec2e2190e3eca41c70a060993d736224b610666fefec5a044cfcc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "233a751476536a5a7ad0719f5de36b7b32ad788cd8ecebfaa19b869cdd457f10"
    sha256 cellar: :any_skip_relocation, ventura:       "233a751476536a5a7ad0719f5de36b7b32ad788cd8ecebfaa19b869cdd457f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27d07ce6bae22a4dd608f84671b81f150881dde0333923b18a211e9fde35063e"
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