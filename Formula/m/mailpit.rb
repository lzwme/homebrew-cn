require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.18.0.tar.gz"
  sha256 "1ac4cedfe926021e8b6dd632cc16a8f5180027251bf4ef1c69ad4e0036da7afc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "648c128b583ab2a0167c84ac6ccb2cc129327c98c9e026546209d1b71ebf02c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bdc84c879b694b3d10d45fd7f9d4c34364e3f9dfd46c6d2bda7114872a6a5e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f814790f1ad80ae4f167799519f74e21974e2cbf882591cdb028b1f1370e386"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fffb62b3a821e27195628777366cb64e2ac85a5c62977bad92b277d37726350"
    sha256 cellar: :any_skip_relocation, ventura:        "00fce33be1c85d4bf54cb35afa63662e36128c15cccdeeade50f0f0ef7f3808f"
    sha256 cellar: :any_skip_relocation, monterey:       "1ed0b32fdc0b2c1f8375283e6e49562035ff8b29b4e62aa894a112c8dfb90e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be8ae673705752669decb8d44d1cd6123ae62ef4ea56e5c2348f0c1f965d2222"
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