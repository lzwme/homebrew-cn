class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v1.80.0.tar.gz"
  sha256 "d58e2d0a4ed5e83e01d1a736b00d263d44ce7ac673504e2f1068f059d57a1e95"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aee089fc0871b93ed04cb8583d9877fd64733c0e4fc7bd1e3dd224a7801d89dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aee089fc0871b93ed04cb8583d9877fd64733c0e4fc7bd1e3dd224a7801d89dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aee089fc0871b93ed04cb8583d9877fd64733c0e4fc7bd1e3dd224a7801d89dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6bd0682a1a080c59d80262c599f4792f4da6a3bb10df8d37de7863d902ef3f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feff4e037cecd7c36e4f32e1b593877f1d67f45171e610e5b6d831af780c9162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2211c6ed9ca82bec52f7b6012da795efac1bf297b08ce6b9fd903a875632ae35"
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