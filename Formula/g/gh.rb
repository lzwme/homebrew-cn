class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghproxy.com/https://github.com/cli/cli/archive/refs/tags/v2.39.2.tar.gz"
  sha256 "b08a2839fe1a590c7deccd3e5a9e659c41b550b16d02157bd66b936ea4714c0d"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bdcd95197596cb2f216633000e2b0554f5e5d2cbdef882f86ee110141ee3daf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b09e83313467bc58de5c82bf80a320ecf645082ec4d991047c6f6644ea86be6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a04188d75c1776a21df67808f2bfa9a6f8edc47c10d5dc1b7ccf05be7476f252"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce770205f6ca234b52e43600dc5070b89a01559b6ea25f73dd3d231b9307f1c2"
    sha256 cellar: :any_skip_relocation, ventura:        "4d1ea8cf5bcb609208305e01ca1a81af799a845d5e7173c8d9f9d1a61484f9ae"
    sha256 cellar: :any_skip_relocation, monterey:       "45f59a6ddc74f28d6fc240e8193f81da92e9822dd8d4cd284dd3a65cc48cc5a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2d3e4c3622a32bc34dd84c73cc6c1988db88e4d352c57658453161f278b09cb"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end