require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.17.0.tar.gz"
  sha256 "1b5da004569687799d825787b9dfa42d238a4ab2088f69d547ffb33bee1dc14c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5b439f685fac929c83befdeeee651c3acb1f73f28e7114462bc73a07e712361"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bb08fed6bf0003f21707d03456c3360b9154bb0ce43232bdc0a176c95b82848"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0340053f86dc1dd89cda9c1c13eaa62569ea4e127e10a10a23b988a1582a6fd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "abd9788dbb3daa4cf000526a5e180095676b180c78fe46a9b4882c313e712ccf"
    sha256 cellar: :any_skip_relocation, ventura:        "50a4f5b45bf797c25992aa873d9671f35e0d43c1eda3791b43ff913bf5b7263a"
    sha256 cellar: :any_skip_relocation, monterey:       "8adb63bd710703cdf3ec7574f63780bfdb2abd87ec8f5a5ca2367c6bf55dd82d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f7650b84b2bc2bf50e25f732d857a0e551f0e66edaee142b5a66416ef77b677"
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