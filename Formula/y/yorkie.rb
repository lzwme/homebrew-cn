class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.4.29.tar.gz"
  sha256 "3bf09d06f1c4d1679d3f81949f88d80fe0b7196a9442b77dc8c622dd0f969c82"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7682826ce3ef83dda22efe9adc3e957f0fdf6845cb5908806c0b925007731c0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41e2bf2070aaaa9b1267789f6004a05e3ff4fa5aad01d047a86b50a767d401a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea77bfe9b731ac75d63cba4daf22bcf4e0541a06fe9b47c518e68d936bcb55e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "db3a26506812ab4626ba74b7e8aec5893907c3a345bc0c430baed8fc8a6f53b3"
    sha256 cellar: :any_skip_relocation, ventura:        "62ac74b0e6c79215e23c366988c5ce0b753b5ac85cd8ad6a3eff377423885d48"
    sha256 cellar: :any_skip_relocation, monterey:       "cbc7a309b1443b113a6a57e31ed1e364534903dd74b9b66cf643848def9a6ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96fb54badcb989ac5abe87f5c4b9b2a32f45679cadbd8b205a42f10233a4f859"
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