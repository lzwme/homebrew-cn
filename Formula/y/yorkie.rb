class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.35.tar.gz"
  sha256 "a24886e773c244297c6f970b6f3c5cf5010dd5d285616f30611cf32934d4a7e9"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36f0fed8bb957c7bee43945bb3c28a1a01ac08c1a49d1c806d700be22593f5ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a70df1d2f39041e59aa83b44966158a449c5bb7f5ba94f434f86ff17f24beed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5760321a0a7c5e835ed51c1f1fe850c215226e550a271af0c55039e1b437e1cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff1c7cb00b57c5c31e3543c27c30aaef4a78262951d65a5771371041fb9e514e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7146cfaa0df70e6bda85c4be7d9b860d98941bddb99a0e9ce608800bf8e3670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d242eb2bc89e50964ca3358c17d23e3a3702c5eb66cd249a03497f4130974fda"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", "completion")
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = spawn bin/"yorkie", "server"
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