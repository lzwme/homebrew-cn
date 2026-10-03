class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.23.5.tar.gz"
  sha256 "2fc927b0b8d9ea5a13bd6cd50f0224db64ad204698e426f25c042b1529dda86c"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "929fb551a6b6d7b252a8b6a66d66f1c1a07d46520cf44e8f4c883c2cf8d272e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "929fb551a6b6d7b252a8b6a66d66f1c1a07d46520cf44e8f4c883c2cf8d272e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "929fb551a6b6d7b252a8b6a66d66f1c1a07d46520cf44e8f4c883c2cf8d272e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "593baa8222b809dfe5cf0574350ee8380a8bbeec37f8951cc9b87c37007816ce"
    sha256 cellar: :any,                 x86_64_linux:      "be11bd9371d17e07bbd94556dc257e739e4b0b2059efc82725fe2fbabbc1eb1b"
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