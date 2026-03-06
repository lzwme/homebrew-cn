class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "d6c7503fec56b8791cceac62473b7bda9cd7f9eed7675dae180d10d7fef6d9bf"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "089ff2a182434608f18469ce8451e3d55665b43eb10618a77737c5a606074324"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ef8ed576d8ac7d37fb150b3333d34ef6fab1b5cb5f56568ce70171c8de37f9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd0d7b9d473b9f1d695424a68c0de2da202af6a84efd8177e3d633d990dd8f76"
    sha256 cellar: :any_skip_relocation, sonoma:        "3206e8200ea2f97411b9085f50d62242d39f443382f1e1048cd0040405d8c8d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f64bea8a07416ce92e6e763dfada9ef74e0b28f1c7393a0306e8639bf26d8bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5bf2b4768b525b6d698b563f6879443766ef044b638451c44fe873d4241ddc0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", shell_parameter_format: :cobra)
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