class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.0.tar.gz"
  sha256 "e50c3dab9846c8cd88d1e2fa5fbde95ee576ce577438562fbdae0a39073cf264"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34db6de5f1817a462118e826e1553500379631ceb27ad01234f8a085d63f66df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34db6de5f1817a462118e826e1553500379631ceb27ad01234f8a085d63f66df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34db6de5f1817a462118e826e1553500379631ceb27ad01234f8a085d63f66df"
    sha256 cellar: :any_skip_relocation, sonoma:        "eba96580550f78f7e09e7fc0e88c2bdc3f2edb6ad41a8f90900ad3f42d00040e"
    sha256 cellar: :any_skip_relocation, ventura:       "eba96580550f78f7e09e7fc0e88c2bdc3f2edb6ad41a8f90900ad3f42d00040e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f6db623c78b4cdc4cedf6a1aa7e3dcbde35760c41033f0c1e17713516534e7f"
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