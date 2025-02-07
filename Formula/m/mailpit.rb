class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.22.1.tar.gz"
  sha256 "192411cee1b8b78710062091ad33f93ea8474352ae780dd0396f8caa8cfbeb82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e548708f0b11ac79e8bdb93329c6a9419ce18604cf9cf9e274a7da235297990a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "407067c29d6dedb00d2410198f4a0bcd7758b25752d03fee861f75da1d4823d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "743bf0bd539ccf04e04a5366e7f767cba3a4c44bb65ed316db6eb46ff793f99c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b55711d1df39e70ade35c07dafb6fd58f909e9ceb7c4e0b988b814935bb6fb08"
    sha256 cellar: :any_skip_relocation, ventura:       "1629aa2cc758edd715e8f83989fca36aa1a4dd2623988294032d8a9216db8e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13e3d3e3279c1241f3a49f69f93379bf198f29610c7b4eacf5af0d33f628f6ac"
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