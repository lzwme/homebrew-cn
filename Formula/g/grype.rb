class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.92.0.tar.gz"
  sha256 "f336e844721f78b928399e1b7b0bc11d1e8f7b9a20daf22b4ff6959b8197be14"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e74e1f2e5aa5d26cd7b6ed307f615cae6582808fc0f93d0ac830843f9861032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "583d5c0bc185b6deae2b523c5276a0e227bb646ba1ee4659d937374e4468bc33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dd68f51b91e125dcc609b497db0c1bffb7c688fa4501288250264ff6cc55254"
    sha256 cellar: :any_skip_relocation, sonoma:        "24537105269f8fd964bbff9690f2a1f2dd0616081c3259e35b8d2b9f0a9fd4fc"
    sha256 cellar: :any_skip_relocation, ventura:       "7110d2834d7bedfa1bba16a4a2731c81829d63b332a116b0e3ff9c286ca3c5df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c851832f9731eb851726eab281a27cb7c9889c3b52173e29290c1782ca205346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "613b7b4064281666ce5128ec9f5780b1fa14fc1845e2d02d5d73af55e01770d5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end