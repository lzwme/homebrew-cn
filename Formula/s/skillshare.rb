class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.21.6.tar.gz"
  sha256 "6052d91ca1b5338375301f2a9e1423653415ab2b25f950161b21ff1da692e10b"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef4dd451e7779fbbf3575263eb1739f8d560d1245e4e9773285e90cde39ecb6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef4dd451e7779fbbf3575263eb1739f8d560d1245e4e9773285e90cde39ecb6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef4dd451e7779fbbf3575263eb1739f8d560d1245e4e9773285e90cde39ecb6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b9ea0623b5acfce082821580fce9bbcc19f00e7200424f93a474be4786beed48"
    sha256 cellar: :any,                 x86_64_linux:      "41ee70c78128ad6f31a25649628fc9448034a9ec4c0095b2b0bcb64a54367cdc"
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