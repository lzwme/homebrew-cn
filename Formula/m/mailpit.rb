class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.21.3.tar.gz"
  sha256 "de574f2906dfb31d7575e78e52ada4ad8e14c7ff1bb21df449cf29a689242a9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b70c853de2af7eac84e25b828aeb439fbfb3964bead02a2d1983672cf96e554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5de6ecd9070ef83b11d9fd2cf4275c13e39a39d1f47c159576cd927cba1a4a62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36dd0a022a52963c2bed70d3da48006e3e651bbf5d44d521abb7ae8ba695e25a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6731a6d2e27a10f63d964b4283ac46472437b29d00a7013534b0d6b1bce4c948"
    sha256 cellar: :any_skip_relocation, ventura:       "88b32353c32e636906bfbdf4016cbe6da2a6e715a22e1d3a3457bf0380c22a23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34b5bbed06ea54071f299197f96073b8cf827a36002cb10b7ad64b97c44f56a0"
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