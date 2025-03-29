class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.5.tar.gz"
  sha256 "917951a15aca524e5706b5914a58224151d79b27171472f579f737cee9fee65b"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07b82f67f76e486b298d3575643440caa5124963e87f149479ffd5a15e6a8ff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07b82f67f76e486b298d3575643440caa5124963e87f149479ffd5a15e6a8ff6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07b82f67f76e486b298d3575643440caa5124963e87f149479ffd5a15e6a8ff6"
    sha256 cellar: :any_skip_relocation, sonoma:        "75a9e1a47b90cd5d85631fca43f7292a9d9377bf6c26c74b24955947e92ec770"
    sha256 cellar: :any_skip_relocation, ventura:       "75a9e1a47b90cd5d85631fca43f7292a9d9377bf6c26c74b24955947e92ec770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97c22267492a54f7847d2f9de0d02c5cf4ac13a923bd90c5e45a7f06997c74db"
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