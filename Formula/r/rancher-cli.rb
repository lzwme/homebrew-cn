class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://ghfast.top/https://github.com/rancher/cli/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "f5e3cba6e4156c68ce0785216898376b636cca8c032cb3807328805eba502189"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3711aaf5f1769a6a00dd98cc869d9bf068435628f58c6b05312989cb282567d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "776e12e582df98007ddcb0c9553b44fc1b0a46381066e21f4cfeb8e59670fb65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ad65c2494db289a6f77fc876febf68106591332b51351ca48533cd96f515000"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f6bd7f57d76d252fc279200935d6782b00da3fea816db3a0e965fa413514274"
    sha256 cellar: :any_skip_relocation, ventura:       "8d2c8e814033fffc3078b1677fb08116d447ef717cbd9956cb218abdb9357206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5acc630163369ce5cf5185b44c63fc23c5ea50c4174eed2788fc78681c9740a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"rancher")
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end