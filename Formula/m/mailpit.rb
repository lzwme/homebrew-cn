class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.21.1.tar.gz"
  sha256 "c03bea0de19620bcfc1316e8d28f79a7b1a57499494ba486851905ec550e1777"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81f3fa9751962ced90b37e635c328da5a8be35d8d0b5d978ec22009bc5a98bfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c5e5b47d27283e77d741abd91a84b14ad42feda4681739f924f69cc5656b525"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41f3dda497106b91b6d3ccc984b36443ab2f81b22f3dce880905d04f684476dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1020ff4fded74f7d5ad72bfa8451ac7053b53cfa922c2192b152117c411db34d"
    sha256 cellar: :any_skip_relocation, ventura:       "3b22c512d681dcacfbfb0dbec54059599ecdee428ca92a567d2c94be9677dad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78d39eeec69fa524b8c560334366231647193cfb3ae49844a77d8cc23ce20758"
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