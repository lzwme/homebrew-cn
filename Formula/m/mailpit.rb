class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.21.5.tar.gz"
  sha256 "d3eb50f50dbaca546fb22206eb009757628109f1afdfce98e2586157ce620c6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2419826422dd30eab07195cae817539bf3000c0623d50a8b943d0b37e76121b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89c2daa064177998c290be316b01dfab9d2f74e85a078bc5df314dcc906b0631"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "869ea4e9e0d788bd6f919952ce05d3af5db77766f3762df40841e3a222e7c0bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2d22e5fd0cb56f42ca40e1b183f884c06fb690477ea07751f196bde398b66a1"
    sha256 cellar: :any_skip_relocation, ventura:       "15a080d63eb5332a2e4d67547c8b2df50b8164fe06c8e30deea81596b4f57b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c15304365a92851535667e4bfee768f512ccb1ccf5b4f032ddf1a17825d24cc"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    ldflags = "-s -w -X github.comaxllentmailpitconfig.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run opt_bin"mailpit"
    keep_alive true
    log_path var"logmailpit.log"
    error_log_path var"logmailpit.log"
  end

  test do
    (testpath"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}mailpit sendmail < #{testpath}test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}mailpit version")
  end
end