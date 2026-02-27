class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "dba12316cf3e517894511c45650d583a28b464b7a2a7df657d02b0d1d63af0a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbb18cf80351d20bf1b8f33bc3e5c47228b1a001a585271571a2b3bcfeebb988"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbb18cf80351d20bf1b8f33bc3e5c47228b1a001a585271571a2b3bcfeebb988"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbb18cf80351d20bf1b8f33bc3e5c47228b1a001a585271571a2b3bcfeebb988"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae6b8342d05ed4225338686f68869b8566ffeca3d29f544f34241da0c5051fd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1cb43747b62c5edddf81aa12ae56835d627ca2a96aaffed7822287e8b0a3d7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0ed58353ea6690203f38b1d5891a8f6779b823dad1f4d3c48281140fcd3a5de"
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