class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.20.6.tar.gz"
  sha256 "58bf6d72c2b692f254617dedd211981554b9e3a275f93305abc6eb9e2f554b82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c05514d73d691d392913d32aa61d0fbdb1868b64493bfa370f84ff4f6cf4084"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3d2d7bc37b37be933f1175d14b9ecc62da394836a30f992b238d8443c7b02cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b40e6f3c7c353b83401c5216aabe19f2fd46e8e35068644c256fb734ac75803a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d25f148a9190a345e485ccb6ca128c0438a3a165e4e4d2e8bacc35f33934afab"
    sha256 cellar: :any_skip_relocation, ventura:       "ca1d6dbeb7038cd11c8f5bf92f0be3e1a30b709aa74b65a4004163b6e8afa231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74bff09cade61345aa9a575997826b745e08004223b84460ebad974d78026477"
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