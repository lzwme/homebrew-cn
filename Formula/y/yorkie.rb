class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.4.25.tar.gz"
  sha256 "eafba274c3efe24988bf5f5257ec2ffce08bc2ada35540884ae9889415ccbfe7"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b344f427d91df550e28db07267afe7c282250c8968589ba8cee5e91b1cfb1a9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a4d56ce7b1e91c137689c3a3853dc7a5828a8a95db6de1e555a819e2c82ba68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb66d6f908ee140f41c8d1db26b0e934e9644c906f692e1482320a5e40cde216"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa4e3e9c0bb96bd8ecf0012fcdc975ecfdef077ee93ce61d16d73017a317d2c2"
    sha256 cellar: :any_skip_relocation, ventura:        "17e8b6bc39eb9a6287ffb6f8f9ac396e8333c87952ad668c37e9b61570d82eb3"
    sha256 cellar: :any_skip_relocation, monterey:       "8553a43dcbe0002cb2b6af8ea7b3eb2bb6cfef262ad9c40726eeb944af0fdd1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45c42b4539e2e98be7c2719df2f387b359dbe0a6242bcdd100d960bb68e24529"
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