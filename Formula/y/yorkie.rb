class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.25.tar.gz"
  sha256 "34ecee0355e53e4cace9163a9eee354734474a4d361c534902c3b49f5a227ebc"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6991a9e63f34ef554efcfdccf4064ec3efeca2ee2a3bae59e093617317a3ff2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d7da346f4257235e872348b7ccb65f8179cdeabd82ba7ab42429a422d489027"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3a18ffe7646b4b0dc679aae84abb99c44629a79f7232b36ed12e684245c306d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b779fb7b90856c42721595b8629b6524242566753ab3b305fa6d8fce5a374447"
    sha256 cellar: :any_skip_relocation, ventura:       "a46542bb495cce47f4ca2101ea4e7ef512027cb02e66e6b7d1c33e5ae6551182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fb41ca762fbf52a4211251cf3f329b9b6d5f777e57b3888942eb60d1770a2d1"
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