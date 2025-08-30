class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.27.tar.gz"
  sha256 "b2864a9bcde68d07b02b94988bdb8e434ccf2337c0cfaa5010c61c8582a43893"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e46c01c237022a1b8d63304eb79d50da6ec43c84742d04739889cb21e6739a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e6737cf1aef36506d910ebfc117488ca2d954f5228079a9b0d4ad0d2f02750a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f561cf00cc31bd0372af4b56e18a35789045de5af4e01792b782b07ca53d4a6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "774ee4a6a5af4901d8f6d2b2371427748eb9f3523d05f1085878005e50dcf282"
    sha256 cellar: :any_skip_relocation, ventura:       "f239aef72c1f4cc62e9b14abc9c8374b18b32984f1d6d4d70239ddfaf307d7ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43a94e2bb4bfa3df6825f49a913dcf6cd52db5f6cc250e3da9892f578a81d860"
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