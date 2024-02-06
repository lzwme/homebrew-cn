require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.13.2.tar.gz"
  sha256 "093370d018cf89d12b6ecf9a1c9b8504acdacedb25a38aa1cebc20481d627fd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8909db95e1607e2d36850b8d2abce8fd276c606920c97864ef96ebb17ef2ac59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c215cac3edc864647a37188014f9e2faee34597d28c2420cad30a6acd5d2b56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba95d878f8f01bae4dd341f7f5c8e71fb91b2592443a67b466c731999644251c"
    sha256 cellar: :any_skip_relocation, sonoma:         "65d0db9a2b79d4e25f6508d765f0801af70a932999b1917081ad13cde1bb074e"
    sha256 cellar: :any_skip_relocation, ventura:        "e229f0365be8897090dd78675cf25efcaad3b734b49e077f740f76ae88ab21c2"
    sha256 cellar: :any_skip_relocation, monterey:       "091ddfa089b00881bd2233183da44a2c735e8e99a99e81d45994d782882718d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb6fcbcb88c9d0fc7d9d72f517f11abb5d6c4d1d09b3de70a02bd4df88b8ff78"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.comaxllentmailpitconfig.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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