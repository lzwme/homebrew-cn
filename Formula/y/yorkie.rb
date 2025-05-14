class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.11.tar.gz"
  sha256 "e8d5b40d69ad96323909fd5dd19142524a52f1916ede18907a14143393773700"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "360b82ba821a553ae22ba7265ada837695c9171f7fa66eaea69db07e056abad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "360b82ba821a553ae22ba7265ada837695c9171f7fa66eaea69db07e056abad3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "360b82ba821a553ae22ba7265ada837695c9171f7fa66eaea69db07e056abad3"
    sha256 cellar: :any_skip_relocation, sonoma:        "70402f16235643d73d7c9b52f6ce45a6edba7e2d71e350b719eec60bcee0a772"
    sha256 cellar: :any_skip_relocation, ventura:       "70402f16235643d73d7c9b52f6ce45a6edba7e2d71e350b719eec60bcee0a772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8545e0e00c4b9e9736865be06dc60698f6ecdae8719c353cf10a1449ecf87c9"
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