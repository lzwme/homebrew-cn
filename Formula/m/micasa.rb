class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v1.44.2.tar.gz"
  sha256 "d5fdcd5723caae015bea4366261c31bdedfdb6007a8635f7663445ca99de036a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a4684fc0b95c242800f647b860de8bb3a96c325fb50f42f67d23287217a0ac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a4684fc0b95c242800f647b860de8bb3a96c325fb50f42f67d23287217a0ac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a4684fc0b95c242800f647b860de8bb3a96c325fb50f42f67d23287217a0ac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "845f6d119ce9b890384c64408558680f79e2e075f4b8536307851f8f6ce0beb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6781160bab5f6976757cc4a449abefef4fe60e4234249d22ab7c95156d87183c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "492148e581982de093e9a6a64e9c5462ffa2b8561c73d4831211642c399154c0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end