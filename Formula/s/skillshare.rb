class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.25.9.tar.gz"
  sha256 "267fd2de9bed5a8926f1b0d8c9f7c5777ca9e65b9f7eb2aec04fddd532b922d7"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7dce24202e5c01499e64cca09f2f53db3d07d6ff02bc381d41f60ec425b0c209"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7dce24202e5c01499e64cca09f2f53db3d07d6ff02bc381d41f60ec425b0c209"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7dce24202e5c01499e64cca09f2f53db3d07d6ff02bc381d41f60ec425b0c209"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e503448c04dd72e2b73c8a57d2a1bda0a9dc671e4636ff06cc58403cb0c6eef7"
    sha256 cellar: :any,                 x86_64_linux:      "4e2ab5bcb27e3ee79a95841b794ac5a88a1ccbe9015974907c726c6406e7a57f"
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