class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v1.49.2.tar.gz"
  sha256 "53b977841fff396d03d9c3158ac95e15668fad74f42c8b800e0dc91f2b6c939c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86399c0e9782924de63116e4b6690b403840914e3a97642b617e2a455dcb5e15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86399c0e9782924de63116e4b6690b403840914e3a97642b617e2a455dcb5e15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86399c0e9782924de63116e4b6690b403840914e3a97642b617e2a455dcb5e15"
    sha256 cellar: :any_skip_relocation, sonoma:        "d144e921bda7aad9b880aa6ee93b6b7fd03f39a050e3a654f404d73d4fa4c097"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be63c0e7be9c5c5d829f8ba6657a556ea2d0a7ce08c5142ad1b3e145926a2cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d0a24581981237ada16f13515e396b0a58e9692530d9fb7be720ea260eafedc"
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