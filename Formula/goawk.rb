class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://ghproxy.com/https://github.com/benhoyt/goawk/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "3846a1bdacedb1c87edf7627ebd67fe29ce7b2cdafa77a8528eb45b22df5506d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7c1a8a8b4424b4172791ba0227fcadb1944c09bdb09d17ab3795470d1ac6770"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7c1a8a8b4424b4172791ba0227fcadb1944c09bdb09d17ab3795470d1ac6770"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7c1a8a8b4424b4172791ba0227fcadb1944c09bdb09d17ab3795470d1ac6770"
    sha256 cellar: :any_skip_relocation, ventura:        "5dfda23fd654036b305267aa097b57147ed9ad9dc8c991979c20f89051674b6f"
    sha256 cellar: :any_skip_relocation, monterey:       "5dfda23fd654036b305267aa097b57147ed9ad9dc8c991979c20f89051674b6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dfda23fd654036b305267aa097b57147ed9ad9dc8c991979c20f89051674b6f"
    sha256 cellar: :any_skip_relocation, catalina:       "5dfda23fd654036b305267aa097b57147ed9ad9dc8c991979c20f89051674b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "149ce737f679b493d4f8a99c042067d2e42f76ba4edb7aef342643d66acd8c24"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end