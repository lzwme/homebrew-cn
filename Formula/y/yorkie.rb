class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.8.tar.gz"
  sha256 "992e02c3a957b4dfd4f8da17ee661938e78c65170935bb7755f9a8ae208b1a6b"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6af59c0cd0e09152f1b8cf5c98ca5875e8d0cf52bb8b53fa2053f319181ac023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6af59c0cd0e09152f1b8cf5c98ca5875e8d0cf52bb8b53fa2053f319181ac023"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6af59c0cd0e09152f1b8cf5c98ca5875e8d0cf52bb8b53fa2053f319181ac023"
    sha256 cellar: :any_skip_relocation, sonoma:        "c17d41b0d86163a778eca6b0abdc60dc609c966fca205e368168444356b0be17"
    sha256 cellar: :any_skip_relocation, ventura:       "c17d41b0d86163a778eca6b0abdc60dc609c966fca205e368168444356b0be17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5a29bb9e3f476342223c114bca440da574ab251b9cc8e377d10740c0a490f7e"
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