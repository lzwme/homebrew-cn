require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.19.0.tar.gz"
  sha256 "967ede59dd800e4652f443e2f467c0fbf994143b4976ebdb1074f539d7e72e67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4954cd15a54f8f758b005bae6b4354c24ed4e7fe6ef6e9a60ef6cd3a940a355d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b716283259216a48a09e65abc83b8541733cded0e619044f8ffc9b82c4550a0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "901b121fdbb561c6878e58bf0e0afee7e58b5686e85a7c5fda45454ff0aef1e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bc673e85a92163f3a32c001af25807310a0cabef75b99c0437e8ad00f77f024"
    sha256 cellar: :any_skip_relocation, ventura:        "9369b64bba80fc995977697cf91b063f12508acc4803f7455554f604449c2c6c"
    sha256 cellar: :any_skip_relocation, monterey:       "e3487150b7c0a7bbbc1a3f757534a5563b57ff649111a4851f607eb5cb659d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c580f4b8fc3ae9a5669e2e7565f47580aa092dca1702e69de27504077840659c"
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