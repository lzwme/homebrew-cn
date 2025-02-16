class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.22.3.tar.gz"
  sha256 "28e7809168db771e75513ea2b033f04a409dec6e75faee8bdc130e6b28904d30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68fdba268ba10fb7260f8be3e063d30f5f18c1f6ab98cef810a1f27b9b18b291"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27feaa46afa22e4c828ea68d7588c326c04525062b4ee608d303105922f27dae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d97126e3b270effcf0e421c4e3c168df60447506277bdb85e464d8cc4314d021"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab725838f6733d1944005284fb24129f06efc9483e9fd9ce6f00bac1baf40e1b"
    sha256 cellar: :any_skip_relocation, ventura:       "39d9821d1b30eb75754321012e5b8be83e1943f726b27bf344a9261b0873c727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36e6c6ee3d9db252261e521d3ec86f215adae29950d3815967713b71c9a1a4dc"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.comaxllentmailpitconfig.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"mailpit", "completion")
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