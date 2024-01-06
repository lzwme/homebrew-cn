class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkie.git",
    tag:      "v0.4.12",
    revision: "6936d2bc9ec4cdd1a33167457b22391ed1dc89f1"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "068795d8a6412af926458d6984ebc888b8fd86291c35e65aafda978fa2e2c118"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59f14b7e5af58ef13ce22cebd07d8df5d6ff3e45ed22f2bccbc6265904784e3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98b6b7ad57cde383ce98ea2ccb5dfe1b7287f9b94075ff84ba03bb1d5d4f80a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccfa3be0352264b894aff9f9092cda41ce400f0b500f5ebf4bfb1c3a5d989b60"
    sha256 cellar: :any_skip_relocation, ventura:        "5bf551a508d265e59ad05b59dd44175b47744535823d349d362fb70433748079"
    sha256 cellar: :any_skip_relocation, monterey:       "1f5847eb00993786c5d073e0afc5065e6b0149503bb7c0b2a6db765de4b07aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83f2795bb7eae90de65b2ed658dc87fae2c586921ea358c398c24ba85d656c0d"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    prefix.install "bin"

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