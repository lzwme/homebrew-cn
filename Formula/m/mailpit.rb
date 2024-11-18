class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.21.4.tar.gz"
  sha256 "be860853b52350b4d0913c719a058ff32c50527ca75e1e18f2f957918be763d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "745370de68ed0c6607dbb128ca5f8f38965ec0c8aa16670deccd689a2d3ad086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21ba94af8695eafe76bb23057a4cb65ab13782743d0c05ebe905ae50fb59ccf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7670b1c863bb5a0439d04a47ce687d98a0b4f0ed0f9e3819be477d3b144ae60f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3483b203279e1ed489784b579e83fa801f752b6db5412c77e7ab7253df43c3ed"
    sha256 cellar: :any_skip_relocation, ventura:       "1699a30e2018a6660e1171419de6fd8587f67ac800d4d9e8905ee69bcacdbf02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b05a3fc6d4d445fbd122553a91e4d46324fc6c7529ac47d2ca21042cc763ad3c"
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