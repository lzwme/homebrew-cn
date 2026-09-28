class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.21.12.tar.gz"
  sha256 "c03cfcb1137263c173a52fc3bd3bf9d4cef4e1a326bf59b78504eb389896e072"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b164780fa97645ee34c70f467aeacf9913ca7906ab4113001cc674a004bdd605"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b164780fa97645ee34c70f467aeacf9913ca7906ab4113001cc674a004bdd605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b164780fa97645ee34c70f467aeacf9913ca7906ab4113001cc674a004bdd605"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "25176b07c2eacb63b82d046d5d0256426f3e9971bd38735ea65ea4861799c3bb"
    sha256 cellar: :any,                 x86_64_linux:      "55f2bc0541c6f70a83d46931bfd81ed794de4ee6fc9bf17b3e8f1da5addee411"
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