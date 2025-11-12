class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.37.tar.gz"
  sha256 "566a3272afc2ca922972e800e625961fa48c1e749dfb6241f4cfb8ccfdd786d1"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51fc5ddd587b42c54db7c5946871377d3671a0d26726aebb986ae98c85340f06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20d379cfb9bdf8dd96c6a9854b71ee5a263f4a669d3da38302e223040479c97d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eca89ca29e50e192f2a7d335bc2981598455e65ff85e8b5818a1d5d408fd70c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "700018c3be9e1a4cf750d8254d67d637c4df39d8a917d02dfe5d97238fcb77f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48957b988a893a6659462de439d6852a4b41d8c08a66370dbf2384c8c92e2041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "659a3b9043376e50a6767f254054ae9533a6a4941e7a65f13528c927a769f207"
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