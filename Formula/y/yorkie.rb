class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.9",
    revision: "8a33500b705df825911e7d83c1d3f475940b5022"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aca6905ef0d752c12473f8c7e9fc8dc49e0c027f6f4c62791e3d2117784507be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9a42e0c7477a9ccef2880c04563f93ef1f610c21bf52f727bd8af9a002b3fd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee0222d1e4525f99c29d8c373cb471c812cc03f1064ce336e078b76b598d2a0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8975b963b3f33ed93e00e3892ed840077ab8877944a31fb5fa6faa2a818b9828"
    sha256 cellar: :any_skip_relocation, ventura:        "d923f90b3510d136f82ff079bf017a0069fa546e7eceea84ad12717a57eab4dd"
    sha256 cellar: :any_skip_relocation, monterey:       "47fef5f22985e821cfc33638fc3a50ff8e9df5da76fa4862b118eacc0b239bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c85586e6f6fa11d3b2118d7096e1832385ae348ca3960e72f8d035b25202115d"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    prefix.install "bin"

    generate_completions_from_executable(bin/"yorkie", "completion")
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = fork do
      exec bin/"yorkie", "server"
    end
    # sleep to let yorkie get ready
    sleep 3
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin", "--insecure"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end