class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.81.0.tar.gz"
  sha256 "54bcb975e6de53561d30a46aca6919e2e33ae6588c1cc55d21c64e1d1380b357"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9354264c2b6526e8f620e5aef44827f526dfc7881dbe1e0f649ef7b01628059"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9354264c2b6526e8f620e5aef44827f526dfc7881dbe1e0f649ef7b01628059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9354264c2b6526e8f620e5aef44827f526dfc7881dbe1e0f649ef7b01628059"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ae4ae4d7c7a94d31bc58c32eaf121043dfa3325efebbbe88d54d97bbbb2db88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ad4306cb1a0e12ed4db862e04ba367abd7db8539ebdd3119e0e470703bc41c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fdf2b30317a6eb4a1b2543088a5b23bbbae1218e29bfa8140a70817810840d6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end