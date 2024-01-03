require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:github.comaxllentmailpit"
  url "https:github.comaxllentmailpitarchiverefstagsv1.12.0.tar.gz"
  sha256 "c20480506484a0773836d8cc57c379cf6eeeba644d489f87522abb52631f5ce5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcf5ac4f663fc1b7e90578fe0660bd6895ccf41f394cd2ac9fb7cb384791e8bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a8ca71f107822dbaa7292305298ee240bb44d3fc4dda583147711976d1b841b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08bc03affed01c0e80ea333c5fb07e7a883885b3acae8760283d8cb094452eb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "cff841e08b7b75d126ba705d85b3900c256ddb0159e5f0096726392b9d340c76"
    sha256 cellar: :any_skip_relocation, ventura:        "3fa280f38e01518d6a45a036b72f1e2fd6228e3af4ef7698b96a55cfd772f320"
    sha256 cellar: :any_skip_relocation, monterey:       "b4c28e07c25f3f4bf808c7c8b3938d71e036276bc29fe1adf321a2f5dddca522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b1a982a559f1013dee3e805e4936957582531f700f532d2e4994b2286fcb47a"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.comaxllentmailpitconfig.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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

    assert_match version.to_s, shell_output("#{bin}mailpit version")
  end
end