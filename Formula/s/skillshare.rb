class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.21.9.tar.gz"
  sha256 "532e9fe87f42cc650a8c7cea7e4ddf7d76d753eef754c1b6c096aa51ce45e099"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1886c80e7f810eeec8696603164071cbe0587c5b9cd6e363bdb6efdb0ac64e49"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1886c80e7f810eeec8696603164071cbe0587c5b9cd6e363bdb6efdb0ac64e49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1886c80e7f810eeec8696603164071cbe0587c5b9cd6e363bdb6efdb0ac64e49"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9381117e05b919b6d075326f412375da8de3dcc495c2d673a55eee82d427b502"
    sha256 cellar: :any,                 x86_64_linux:      "af3776f95f3919486d41f5ab48f24425fe7953744dbe0251b61c35b3b316c23b"
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