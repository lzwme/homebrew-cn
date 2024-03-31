require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.15.1.tar.gz"
  sha256 "3dbae56c4cc6b9950dfa7b4f571a1717b8b9485208bbf8f387e1b3714c0e2d16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba83d81972dbb3624f018dc0d86f687e314791d193318d2e9aded13395159196"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82a8d53064d1109d8b5cac482e64fa5a4fb8a26af37bc31f6aeb29ac86d2bf2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e5b0b67d1d4a34b7e8ba0d7e28fd83107bff572bf768b8a06deb31d3bcdd58c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f8f674362fe489f7199ceea9fb1e179a2de75e0b7f5e40d1231c2a97e680fe6"
    sha256 cellar: :any_skip_relocation, ventura:        "bdab968016c2e311f8e54afeb6aa5ec8ac0b6067a629cd7ef5526867c420f004"
    sha256 cellar: :any_skip_relocation, monterey:       "29a18741e1d2ac52755151ffb28d95ce86395eda1f39de34a5809fe2082c2634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ecc98036a977c73a3d5dd272ec432297468fd03aceaee5b1a4de5944735ef41"
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