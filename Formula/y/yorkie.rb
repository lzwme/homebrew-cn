class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.34.tar.gz"
  sha256 "1d8033b47a67064ceb6b1d40b69b6a7beb1d6fe36f51439a227f42848c226e8e"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d0dac61dafd827f0a4781b4308202051a16693364f9edaa62c5ceb639f59ebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a95746d5d783af556366eb94158ca119bad02dcd4334ba39bbc69e04c12220d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec8ee5e385c42ed51ea6d3b758747f1b77ec4cdf234459287aba4d554e8b483"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb8bb2eee0651576d2eb052d98cd170516633ff2a7c0e1ed75d3383f5e6d226"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff71527a08f7872a0b5c159de0f5bd9499ea4a5f6d5e79dfde0ffa15f64ba930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b67240d2c4c20142892805cf07709196f28679321aa2d0311f1deba0d65a6786"
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