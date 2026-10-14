class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.25.11.tar.gz"
  sha256 "0b648d81e30fc04f6b6cb8ebcd22153182697635a85185dc082be86d1831070b"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06d67d7a8b3162cb0f052b6e9ba5accdc784d631659e4281d69394999cf765e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06d67d7a8b3162cb0f052b6e9ba5accdc784d631659e4281d69394999cf765e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06d67d7a8b3162cb0f052b6e9ba5accdc784d631659e4281d69394999cf765e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "120b3523a8c6ec7b4b3842dd718403553018b9bb73bd1cd595492f5e0393bf5c"
    sha256 cellar: :any,                 x86_64_linux:      "7fa573d855a931fa59ba5a78b2ce351ddad5f160cf040b842c5c93b19af86b2c"
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