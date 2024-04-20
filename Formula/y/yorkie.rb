class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.4.17.tar.gz"
  sha256 "9e123c62c2bf8a9d79b4ce24f4731565394485c9b624208532406fc8968f0afc"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab125961753749b35e4f3290fdf3f468b1cc12ff412d085c014bfeb6831fb227"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e7820c064eef208e4eb7acc8b69ef2fa2b8ea16f345d52ec56acd508c5b2662"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca6a5b9bb91a9a202bb4fb741deab9b7e23aebee0b30bca4fb7b65525589253c"
    sha256 cellar: :any_skip_relocation, sonoma:         "90b75137298056a9af18b709efecf174321403c18a1f0a478031297507a312fe"
    sha256 cellar: :any_skip_relocation, ventura:        "8535856e4e42d57c412632e520a1dace4343f9eaa6f460332e6ac942816af354"
    sha256 cellar: :any_skip_relocation, monterey:       "dd35b79f6c1decee86abbed787d2d2b3457e385dfff6ce4024fb320e3c397d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e32e19cf571ba6d4cb3a7ee2f0b16408feabad70b7b4f28a06ed6c6db9645166"
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