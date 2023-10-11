class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "eb54c0d1e6d824d7fc7240a8e9dd15b642bb4ca387f7bbc8de2cbff779635a19"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f12c9f516a7b8d2a781339820db104e400c506deb693a228c297ecf58390703"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45daf5131f89674e99304b0ebcc28ff1756c12f9ef1c1dba9429a606e566d1f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4b97121800a596eaa988243d9968bbef8da49d8cdc4430bf91f447f3cfc9652"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d8052bb875a7591317a250f09470d4e8ee2ed48e33c402aeb1a0b418b5f6905"
    sha256 cellar: :any_skip_relocation, ventura:        "dfadf2b3eb834e9e14b525bfc032fe48d7b9953b247d828784431ce8f0c283ae"
    sha256 cellar: :any_skip_relocation, monterey:       "4b701d613d8e53024b710d1c3b3752dce877a001d0199e9ad76d6b3c022cd147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c9121146a946aaffef5164dc4eb4162f6fd31fd5d4e6304913996a9b3ed4bec"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end