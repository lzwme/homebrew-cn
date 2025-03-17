class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.23.2.tar.gz"
  sha256 "2a0e65bf985eef44b7af81e534ed37d4c77e0609c6e19eec580f6436a5355586"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90ac524d491a70c12dc4cc8fe5dacc854b624eb6708d4eef29d5b3acac5ac24f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fc2965b287c3f3c435051ceb15c8ab9be9a01b55ca9f377f2b92753899751be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdc5e08dbee45d423d559c725ca8115679fca5b1c0fe8ad53eede2dcd9c3ae0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cd506919b6ae3438d9fa26fdeb0fe536ab17429f605ee4ac592456cca955c77"
    sha256 cellar: :any_skip_relocation, ventura:       "77362eaffc4000fcb793928d04bb47795d93520fd12eb0ebc5a18de00ed546a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b1a930d5e0e63e148f7ae79d1fe8480620ac6305e450771ddd6e5b412720f34"
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