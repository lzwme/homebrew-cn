class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.9.tar.gz"
  sha256 "a52db6789ddf2e15181c20a8e8febe20589396b58c5dcb0d84bccadde6b3ee89"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a7356288c3c65e542d7208e36f8c9d3c39d0f4a7df91dcb7c3c00e0110cc004"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a7356288c3c65e542d7208e36f8c9d3c39d0f4a7df91dcb7c3c00e0110cc004"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a7356288c3c65e542d7208e36f8c9d3c39d0f4a7df91dcb7c3c00e0110cc004"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf6d04a90d3783966b647c0ef15e7ac0d231ba56d3d4eccb29f2a57cecfec957"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6caf3c0f592792985d71604c72f1ac10c4baaeca927646bfe259d25774d37d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bc0a9a4eed7b61d6b28e0869339f5b4073eb33e56ad3ffe72db47cf91ddedb1"
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