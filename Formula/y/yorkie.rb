class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkie.git",
    tag:      "v0.4.13",
    revision: "57866e8fad243026e8990a298117cbb3c295459c"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de79d22f42f6f82af86f65cd48ab3e4de0832ddb6e6b5f445d1e5718f9436e4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60df86c308d344947147160f5b38857b06628aabb4a36f5f69be5372bc3f5dee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67e57b54ca2d3dd52f0d451edf20b9ef4f3ee053f2be3500596100419170af13"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5e76cf4eaf351b1a0aa145c6feb6312244554c31729d94d1226c2eba70386fd"
    sha256 cellar: :any_skip_relocation, ventura:        "dda0f139da6dc52491cdb55a9ced0788dc4621a108e7ffefff542369f3c0c927"
    sha256 cellar: :any_skip_relocation, monterey:       "7e975cf93b334263213ca647c39517a74673219e764b4dd196c3b83d54466e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "556121c422f89e79f4a342f24ab1f61087fe8fdec3c52c3d4738c14c3282042d"
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