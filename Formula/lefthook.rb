class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.9.tar.gz"
  sha256 "0daf9b51476cadb43bae2c25ef331ac16013d18b958314c267d43c29822dcad3"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0014438484183e9545c5684ce792eadd3c1fbef1644e0834adb830222da7f7e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0014438484183e9545c5684ce792eadd3c1fbef1644e0834adb830222da7f7e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0014438484183e9545c5684ce792eadd3c1fbef1644e0834adb830222da7f7e6"
    sha256 cellar: :any_skip_relocation, ventura:        "ddb9afad3bb0928c55b823f7200070964080b8589662ba9b7b755cda0692ffee"
    sha256 cellar: :any_skip_relocation, monterey:       "ddb9afad3bb0928c55b823f7200070964080b8589662ba9b7b755cda0692ffee"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddb9afad3bb0928c55b823f7200070964080b8589662ba9b7b755cda0692ffee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6238503f78eb034315b2cec9509bd8c1009ae616f292e7305b7a2e1f18be0652"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end