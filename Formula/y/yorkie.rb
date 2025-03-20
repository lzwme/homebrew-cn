class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.3.tar.gz"
  sha256 "4bf844b51ae24a6ca8baa1ff21588cbcf5c329d7d90b59e0b17b8ea0bbf3b018"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3f34c4c341d946fb4329c377a622ff618bda854ae3fd55b445f0b5943ba983f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f34c4c341d946fb4329c377a622ff618bda854ae3fd55b445f0b5943ba983f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3f34c4c341d946fb4329c377a622ff618bda854ae3fd55b445f0b5943ba983f"
    sha256 cellar: :any_skip_relocation, sonoma:        "98441326f63e8cb76c8558a559045205c7b429d04ba49d99ce54acd29d78ee40"
    sha256 cellar: :any_skip_relocation, ventura:       "98441326f63e8cb76c8558a559045205c7b429d04ba49d99ce54acd29d78ee40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1bfff48c7f4e12e430b1df6c65b1ca2d1fb1d82a72e8573c6eecd0090d48e2f"
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