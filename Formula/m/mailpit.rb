require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.19.2.tar.gz"
  sha256 "1c4d3c44659a51f1bd14cc98c21b1d0fefb716fda29d8b6047e31ae8a6c8d54e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b474826bc98db51b1ca200701f92143316abe2e53c869c32977adf26fb87cd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d40bb5a1c5a94aa030759c86d27b24e5dfab1e8edf584ee12d2598a015dfa0ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a8829be9584bb83d306ad232bfa1ea8a8288bc3147a6363e6c1604dbad4e05b"
    sha256 cellar: :any_skip_relocation, sonoma:         "be16f1760786659300672a8fd7735296bae6adc0db06c7552f1a9468f8ffa8de"
    sha256 cellar: :any_skip_relocation, ventura:        "8aacdbd88d959530a5b2c5b1cc2872793dec8bbf3dde429cfa91eea7a9465504"
    sha256 cellar: :any_skip_relocation, monterey:       "9fd54f894eb2c23d45a084f19375ad408aefdc76944734ed3c93f28b7ee19037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "232c1396b1a566705a55a4c3898530c8f7a34e37deed3028b29aa2b1b9193d03"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
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