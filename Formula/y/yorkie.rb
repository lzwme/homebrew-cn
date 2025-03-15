class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.2.tar.gz"
  sha256 "27c8de8bdd20e8caa5c94bd0694c99ca82bc46355f185cf6be8d482a781b9c96"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75c106672d073c6e92467a06cae7ec31ad51dae7153775fe7b4ea67e8e129147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75c106672d073c6e92467a06cae7ec31ad51dae7153775fe7b4ea67e8e129147"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75c106672d073c6e92467a06cae7ec31ad51dae7153775fe7b4ea67e8e129147"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b08279056ed35759316dfe256be060415b46d8f1d6d2ebf8d4091c5cb800128"
    sha256 cellar: :any_skip_relocation, ventura:       "8b08279056ed35759316dfe256be060415b46d8f1d6d2ebf8d4091c5cb800128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65b1fb221056b4efee88a070a3b384e9a89e7642025e98519dd0eed7e31f4035"
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