class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.19.3.tar.gz"
  sha256 "a7eec7ebf90d5f8c70fcfbb57f5b881131d93b6925643c491d29c19ff84bff05"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de1e1aeae26b842406191250bd16930ed171d318734814a80f378b15401a8e74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30d0d63f3bc4498cee94109ebdefca1334c78d9a0974a3335f22b8418765dd69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "866e81381c2332ac1efd9ffb9870cbf0d2d7a92214ebd09fdba7bb97d45f9c2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "586ccb962f3f80e2830ca96d68ad151ba4aa9edf23675281390ff9f1a45ecb2c"
    sha256 cellar: :any_skip_relocation, ventura:        "67d216be9efb2853de75735a86bc27917f22cdd8847be39a47c865338081f8b8"
    sha256 cellar: :any_skip_relocation, monterey:       "ec3b759c2c9858b5d5a135c37e933d306afa9ad66af19c23d95f12634eba357e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49db9ea44e6b5667ae4b9c864b31eeb096c59f9ba6b45494c79a210c64af3813"
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