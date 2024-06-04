class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.4.21.tar.gz"
  sha256 "72bb6d0b50016240125d8ebc23fb3cf77748da9de8f82009263bd7907e23e74f"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "048d30364de20f6d96a065f10c86d784c7eadc260178c1be7dfb353764a04bfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30a5c5b9438135164a008d360b333650545ba54e8d78d41a447acd8194e90a12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d308de5610f327cdcee9327c612971430569bd73adee3b6aa3d9bd823712bc0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "658fd3f81775226f951419e83fb682190bb567d0b688206e2c64c89ce5bd2a4c"
    sha256 cellar: :any_skip_relocation, ventura:        "1c9ee9580047d424316f3b818f87bbd065670803b2f17b853450e53989cfc034"
    sha256 cellar: :any_skip_relocation, monterey:       "070c422849690a804fd71dca9b25af086c3035b4fed41c075b3c5ad7222a7df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3e1ceb700397f40706fc8e5dfce2753494f949356a33cf5e4545a558a854c4c"
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