require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:github.comaxllentmailpit"
  url "https:github.comaxllentmailpitarchiverefstagsv1.12.1.tar.gz"
  sha256 "826bbd4bfa492b06568465c157b135df01c2b634fd7ed16bca8958c569aff153"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "212f91473a7c5b974b105ef3cb846613c423566d699d56e01373945d02f23d7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "462c17577a7b87721b6f2751882f6c23c937ac5becf8cba950f548c54d7d77a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd8c0c2feea60f5016ec4edf57416b314f76a05ab0b1134673e69429e7bd3c17"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f3bb046b085c2f0d982c335159826f4b5127b90a4b350697421518303fa950c"
    sha256 cellar: :any_skip_relocation, ventura:        "62ddffbabedc12efc1155dc7925f3be73ad2078d24daf2f5d7a70c1c3a9dd52a"
    sha256 cellar: :any_skip_relocation, monterey:       "c07e20cb458dabf2b22a0db5d3ad4041607d9485cb164f5856cdfd68883a25c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a426141ef332bb4490bc2c065ae38f6f770a09f080128e0aedcfbcf50f4ce33"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.comaxllentmailpitconfig.Version=v#{version}"
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

    assert_match "mailpit v#{version}", shell_output("#{bin}mailpit version")
  end
end