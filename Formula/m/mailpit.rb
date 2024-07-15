require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.19.1.tar.gz"
  sha256 "4593282659ffbd874e616c9335e76132ab7f26518ba42b8fa71247df610fa030"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af8d68acc3eb329110bcc4aed980c14a688177d1a4cfdb5578e6cd8957df8a4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "753ccc6de6edd4031a69f1f47abca6821842aba7478ba2e75bb13c498a2a37bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ccc55036e8aecb95ab8336761d73d5604cd72b5b792b2f37c529907a5c41e26"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7baa6435d5a05214c756291c8f0e2301a59b17fa39e5950ce2ab422ac3d7574"
    sha256 cellar: :any_skip_relocation, ventura:        "7438ea0ca9f3ac80965a5a883ec7f94dbef8adbe96bed31ba7723ed7162b109f"
    sha256 cellar: :any_skip_relocation, monterey:       "eac9cb5c52b2a1bf407fc3cba484941debf524003a5fbcaf176bb44ca947c4d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "444b9749314b9c930d99ba7bbd27c01149d35883b7acdedebeb1c7ed2fc0c3e6"
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