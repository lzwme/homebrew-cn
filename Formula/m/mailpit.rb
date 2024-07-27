require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.19.3.tar.gz"
  sha256 "a7eec7ebf90d5f8c70fcfbb57f5b881131d93b6925643c491d29c19ff84bff05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b109968887e48b03430f4f8d596613c6a1325fb5c2283afbc9c33ebbec7c161b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a99b8c1a2f511fc948c9f887aa79ec8575f70f1e037778b9af0646100862f92d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9776779783e5ced33479e46b1343582d7108d6c126e8a144eb73280cb9c76a75"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b9a5205bb94fe7b651c02606b991fe95476d0f03da7dccf380427e433c90eb0"
    sha256 cellar: :any_skip_relocation, ventura:        "b7d979003f34a5f967506ecc9b0031e31f50fd2a6bf48509c0868c8ace7c5260"
    sha256 cellar: :any_skip_relocation, monterey:       "b5c4de813c8a8812703f12fda09198ab373a1c8b60f1a4101e0e58bf83896e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2588e6d620cb407d4e93359ecf033f3c61131fd48a6bfbe1aa6c85180acc0dc"
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