class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.5.1.tar.gz"
  sha256 "0784b7893b26f4a0045aaf0c2742b5c5fa7eb916daf85f80df862ed142533e4a"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4930cd024e903a344da5bcf6a0a1aeca0c2b612e22f66b09ab1eff185c505647"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4930cd024e903a344da5bcf6a0a1aeca0c2b612e22f66b09ab1eff185c505647"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4930cd024e903a344da5bcf6a0a1aeca0c2b612e22f66b09ab1eff185c505647"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ffac36ffaf9f42e37bbcb426bc93bc29aac7b237d55835cbb5118cb86f74d19"
    sha256 cellar: :any_skip_relocation, ventura:       "7ffac36ffaf9f42e37bbcb426bc93bc29aac7b237d55835cbb5118cb86f74d19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "971be47b955a6a357623975fcf4e7cb9f003219c06211b6f481d23a753d7d142"
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