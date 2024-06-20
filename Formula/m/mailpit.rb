require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.18.6.tar.gz"
  sha256 "70b86fe1be254da4da3f62004912e2209e69103c58724d4d28d6e5f0139d42e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03bf9d4c2706ff53a6ed1c98eabf6b61ecc34fd02ecc3daad535e7e8aec9c178"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83c86fe12f4fb53c2c5694f3d0510965e49b29e05869aa7cc94e0ff7a234f7af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46064ceaa5668596b9ca84a679b2e29f01418e6db5396e1aab514ed866cf6d0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a68694a7e077e57acfed051babbe869a6133d454bd8d4802f6e33327a489d7e3"
    sha256 cellar: :any_skip_relocation, ventura:        "1ebac9a00fc4e9226e50c500c63ffd88910c2fb33836d5bb01f22c357e2fc46a"
    sha256 cellar: :any_skip_relocation, monterey:       "8c532d6812a392c5a341cc3c8d113609c3c4e0c87a218b18c461babddea5c105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c8e91279189346f6f29fd10e57a66e466985b0b1bc96f621da6cbd022767884"
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