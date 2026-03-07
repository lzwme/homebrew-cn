class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.16.13.tar.gz"
  sha256 "09302ef63c106546bd017c9ba284a596957d3e48e098d34d27127457fae0595c"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61854f6d331be33e22d273b1afe2a8af8f65bb99d27d6593731c7dd0650f78de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61854f6d331be33e22d273b1afe2a8af8f65bb99d27d6593731c7dd0650f78de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61854f6d331be33e22d273b1afe2a8af8f65bb99d27d6593731c7dd0650f78de"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f6a15342b0d3af9835682dfa5678ff91df772d4a490f7a3d95b3e69d213e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d807641c9205b3e3747d24b8f361b315e3a1cc066ac61516abb07e6ae522dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b76c8d258808c9382952a204587dd5bd2b2727675f0e9656f943dba68c22e8a0"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end