class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "cdc728a1bba480f4df2aa19d26eb4e28eaec63bc7dbffb6a3741a962d86f1a06"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b9d3b3fb6f245978dfb30bedf556adf31d026da40290fa317650dd7661d3e09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b9d3b3fb6f245978dfb30bedf556adf31d026da40290fa317650dd7661d3e09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b9d3b3fb6f245978dfb30bedf556adf31d026da40290fa317650dd7661d3e09"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1b86b1f3f1f93ca4bba949634b2fb57c5afcd3201c7b3733aa6b1e570f6cfdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "947bf06dd929f46553462c9a9d3fbbf3d9f3d8533ee4e5b92e26a61aad528168"
    sha256 cellar: :any,                 x86_64_linux:  "c8f852906a0154d4dc3d91ae988f36fe3d6585153528ed9b0929f05e7872edfe"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end