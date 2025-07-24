class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.21.tar.gz"
  sha256 "d67508c6bde8f948cf6f3fdaddfa9f7a710746408ec29fa41b9344a7aa7c04f7"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b59b336e30f5baf644699c47ca730cbc80e9fbb3c75829f5d0f664c6dd74b4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41a0f08761abebd16a2b78ffbe1e31349d91ce9cfe4e97ed2d934341a319dda2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ed00126bde5998fd0247d6c5e9ff5d8ad0a3e1e9d9ae5af6dba580d803cb1c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9a350023e557a462ebea4143ed27cc1f5c33a2e1b28d6941f7263e7c1d7c5d8"
    sha256 cellar: :any_skip_relocation, ventura:       "2ac8b59a278e9f4fe51b73d9710cf3c96ae07daec9626a00f78a4fffe0557280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b26d271fd78d4e6f867050a760e49835276c98f29f008b465dcc3ed0425183"
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