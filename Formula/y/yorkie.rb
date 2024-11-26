class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.5.6.tar.gz"
  sha256 "b07575b3d4e6207f98ada58c4af59470032d9c54423d7bd66bf565aae063f049"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b43469f3d03f7b13500e46524ea8ef94bf7b3e850fb9b7bcf6fec9dcc56f0862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b43469f3d03f7b13500e46524ea8ef94bf7b3e850fb9b7bcf6fec9dcc56f0862"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b43469f3d03f7b13500e46524ea8ef94bf7b3e850fb9b7bcf6fec9dcc56f0862"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8cc142164e4c08010991aa3e890fe9620037e3ada12a96a2f31e8ba43786f16"
    sha256 cellar: :any_skip_relocation, ventura:       "c8cc142164e4c08010991aa3e890fe9620037e3ada12a96a2f31e8ba43786f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d87cfdd32fa9c17ba83e810f2651a0db81f16aa4f8efb98133cdf75e69c870f"
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