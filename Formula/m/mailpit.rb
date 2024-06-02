require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.18.4.tar.gz"
  sha256 "476b6c2fe712d09e12accb2d7ab711315b86db8e368b37af22198618a62429fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b7ac351c9af156daa2767041ed66422053766da6ef5363a292ef1b76502d3f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20a8e81badb50f9bee182a0356def0b271dd22d345cff7ceb53d26c34293acb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8da7f5e547d997d33850c593cfeca438e40891a8a36eb2d95cd44e53f8607210"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e26ba0463a7320fcfa5ed7bd7203d125b552d05ac9d7f76d8de9e4cc381cc93"
    sha256 cellar: :any_skip_relocation, ventura:        "0754b8ec1a604fa547174db11eacb087eb2d736e5e1f3a891e2c2dba35d734ec"
    sha256 cellar: :any_skip_relocation, monterey:       "b4c8b40691ba4f792c39f50ca25fb07beed3fd81803ec078b6292d06d53c67bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ade9a7f0f677e1d475f147121b4840c0d874df5b645d122b847aa485e4e9dc57"
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