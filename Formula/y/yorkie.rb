class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.5.7.tar.gz"
  sha256 "1f89bb2dad546944b2f987a223b630a129142440ff55180e56e55044cabe0766"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ce5e9f6b2f5c58242f462f79e88130cfa8f1cac6daed6f136ba2c215b5b1b8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ce5e9f6b2f5c58242f462f79e88130cfa8f1cac6daed6f136ba2c215b5b1b8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ce5e9f6b2f5c58242f462f79e88130cfa8f1cac6daed6f136ba2c215b5b1b8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1fcf274b4fbd831563604e1f1e6f9e5368ba96f1ebf0f75cbc266dc4283b471"
    sha256 cellar: :any_skip_relocation, ventura:       "a1fcf274b4fbd831563604e1f1e6f9e5368ba96f1ebf0f75cbc266dc4283b471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fa519d6bf59d80ddc4b37d4ea294e7726989cd335568ea340eac3c55bd3103c"
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