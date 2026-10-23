class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "64c9cfce134001c44e048c300daaf49de4520a2c4bf7972ea44214ee68d53b2a"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26f0b5bae8d49926726d4c501e8070124fa542742e77dc664c8112dc7b35d5ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26f0b5bae8d49926726d4c501e8070124fa542742e77dc664c8112dc7b35d5ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26f0b5bae8d49926726d4c501e8070124fa542742e77dc664c8112dc7b35d5ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "834b3b898fda1e029d6cb345c205bcf920a0ca3daa175330ac88af7cd1f301b1"
    sha256 cellar: :any,                 x86_64_linux:      "de7980ba5503af5ac81ba4021f4a6ac0b8a36675a69e7e5b03ef605d424ab44f"
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