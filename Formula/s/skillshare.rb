class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "2d4edfc8adde1283a6824e620f5eba132a35a8e3aa7ee117c89334f85c014e36"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67919360406d8313546f4b3edfad424ecbe4f37580cd7a2f8b0373c6abe3415a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67919360406d8313546f4b3edfad424ecbe4f37580cd7a2f8b0373c6abe3415a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67919360406d8313546f4b3edfad424ecbe4f37580cd7a2f8b0373c6abe3415a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1aa392af092de1224090573dfe3afc824b68358b50d537876bdb4bb4c87ec4ef"
    sha256 cellar: :any,                 x86_64_linux:      "b8ede0d1219439f6949892af6037ff498907de428c2630880dd9957b12315eae"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end