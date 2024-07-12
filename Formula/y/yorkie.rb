class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.4.27.tar.gz"
  sha256 "487b05488d97faf89e7899207cb18953464a0910370909f1849c4430daf61ba5"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72439f81561ab224ae74b732ab49a7fb03bd4ee487246dc8fa8a62cc8173709a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "517c7c673226a8f81444155f36ba80c2936c445c1510a595967aa8f5751387cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b69ec3401fc711098dfcf70e1e8e00c3333e1b557a29d157ed994613724f101"
    sha256 cellar: :any_skip_relocation, sonoma:         "7795c1b3e4d041646ba1f8b7c12c7cb36af74ae7ab8429a43c0a2b2a0339553a"
    sha256 cellar: :any_skip_relocation, ventura:        "cb61e9a3b374f311ad1d4504c63ccba0e4b76f181ae7d13d4c27a04d563d220c"
    sha256 cellar: :any_skip_relocation, monterey:       "4277ed3103e0f4ba8cc14a52ec0f16895add5a4951ec41619c5af609e773f8a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1352160d57ebdd05465c985aa94fd0f62be58e075ad20b2186639bd628d835d"
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