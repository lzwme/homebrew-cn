class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.23.1.tar.gz"
  sha256 "17e4d640a9d342aa11cb5cfd39d539c74cf9144445431dfaac255c3798aeea16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7f2ad08a5ea1ccdfc5f8884f6f5994860520ab81fa3d45fd5b005f1ff10b89c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd01e0e8e29e91fddeb229cf97fa3ad0b7ca9eb0366ef0840b687cac61c57eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f28ea1f758ff95fe9e3519c6e6e98ef7836aae8c20da321c7985573c0504d6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "90e3d55d5e3ac619c1766bfe5e7003996ba36d3097860ef1cd22b50ee6ad9286"
    sha256 cellar: :any_skip_relocation, ventura:       "c67b9bbb19d7dc313dae9449f4801f3b5665828f5fe2bd1df15baa4856ba3ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac66c49212d7f46fc4fccefe24fdb18ae48a63eb7004f07a8181f3ab71adaced"
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