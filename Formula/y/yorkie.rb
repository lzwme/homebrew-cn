class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkie.git",
    tag:      "v0.4.16",
    revision: "13315ac7cccedc5011a4dba320a73beaa6704837"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f230bb8a69ebe8ea4c2ac374f0f2e9cc1bb1d540479b6d5e2a1817231051eb54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7892653b6ed3bdc27390d32ff033a9d4ea73dd31a5ad99ba5eb2253c7ebfa65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d6477ca2ae9d5e0d1ec960f83f858594889dc3d3fdf5cf0f3d5353fe11741d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "afed9560eb6ebb2af76acc06d5abc91ed88e54c0584f120fee28e2b1f4aef84e"
    sha256 cellar: :any_skip_relocation, ventura:        "1a4db7f67e71e8e91c2015936ec13499b20e16d3e8a4f709e2f41d1ee2a9bc8d"
    sha256 cellar: :any_skip_relocation, monterey:       "9923caaaa12ae44809f460bd3e4568c026642a04d275741fd36d588ce019522d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97c947e2dcda93c8a48b923d08e1e870d2dc0ba35380e3433eeff0121a138bad"
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