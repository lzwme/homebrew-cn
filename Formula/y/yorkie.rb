class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.33.tar.gz"
  sha256 "f277d6b6eaf7af8ec7e2569cb3062aba7387a7d4394a7d586dabb2c96edd79bd"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "513b5729a89d12d15321e6401d8f90d42a5df8b04c7536bf2d4fac33013a19b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4474766bb7879cb15e4ca9fa7e433064b34597c9318a53c473048431969bb42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "607f3d23624dbeed3714b6cfd30e3f6ac78bf1e47c2125d58ce1b99db3d9d3f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "adae9a7b20cc5315cdf16132718ab63d0e1f6b8f4a51086b9cfddd7b6fa756b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "692eab48ec40f7ed7b7824a1b8119bb4613950a2f2abd613310261027f51283a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44b38c12ef81e81355f12a8711777f66b38c3ad4f5fc5c464d11adcc473e52cc"
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