class LsLint < Formula
  desc "Extremely fast file and directory name linter"
  homepage "https://ls-lint.org/"
  url "https://ghproxy.com/https://github.com/loeffel-io/ls-lint/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "48d7f26d9273b040bceb4e424e6ca9a366ea83e580ba7dc39a4002bb6f7069fb"
  license "MIT"
  head "https://github.com/loeffel-io/ls-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31560ecc1626defb1ee63eea7002e6a5acb50487d242ad7662a3fc6f144f39cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31560ecc1626defb1ee63eea7002e6a5acb50487d242ad7662a3fc6f144f39cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31560ecc1626defb1ee63eea7002e6a5acb50487d242ad7662a3fc6f144f39cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "575f0b3dc9ab817d4844fb973ea40e8788c12e9e075b3f0e3a262c785850a968"
    sha256 cellar: :any_skip_relocation, ventura:        "575f0b3dc9ab817d4844fb973ea40e8788c12e9e075b3f0e3a262c785850a968"
    sha256 cellar: :any_skip_relocation, monterey:       "575f0b3dc9ab817d4844fb973ea40e8788c12e9e075b3f0e3a262c785850a968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1f73584ade68af42dfd808f8314b80a14f1df0fcbe56942e0185e3556006e37"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ls_lint"
    pkgshare.install ".ls-lint.yml"
  end

  test do
    output = shell_output("#{bin}/ls-lint -config #{pkgshare}/.ls-lint.yml -workdir #{testpath} 2>&1", 1)
    assert_match "Library failed for rules: snakecase", output

    assert_match version.to_s, shell_output("#{bin}/ls-lint -version")
  end
end