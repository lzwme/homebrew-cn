require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.18.2.tar.gz"
  sha256 "fc5b3c81addd39b142eaee5fb2a6ac8ec939feb4577c4eb3497e481b071ffe53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9add24eb74a63b6d405d31d6863ef04fc6e123f59d272e5b53a272b14071fa05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "684901c00123c0adbc570de207f49eebaeb9d5e3e1c034031fbdac78c2805035"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "665da03ab924e9f0b996380e3677891465a755123fd7753aab2051e44ff6260b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d123a575cc2087518d41fc95f77303f45c5284016634eb6f3ba84d697f156a44"
    sha256 cellar: :any_skip_relocation, ventura:        "22cbd457b4a0b6f526498f4e462e3bb37386a4705781322986952cef78718e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "201eef7f642e6d0cfe238ef0318b27d90423bcef9e12baa5c10b5195d01ac678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e74b4da17ccfa78707b9a4e9dbdc3e2a4eaf3efaeeac41de576758fc691ed81"
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