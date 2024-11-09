class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.21.2.tar.gz"
  sha256 "7457715317020150d1f3089acb5ce44f6188c0f5ef75600545769dfe3d75c158"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa25e7942f6710bd28d03d5e1fed2400c77858946441f62e26c0b3da1548f9e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e66d69c9caeef8c53acb7ba06faf1b650ba50e9929bbd2245a921553322f745"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf27f8374d58ff29d56a0366a534b4502891236838155084b475f5de406cb6ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b45ad3312da81bf29f96699a892839d603126e74490f5cd60f6ea34c690d4a8"
    sha256 cellar: :any_skip_relocation, ventura:       "e588286d20aea0a228c4e92c7f99051d28dea5655009920634b544fd0a32c4ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d3d106209aacbb84a70317edc608a802f8a70c24cf73ffc5f7d6eaff9d854f4"
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