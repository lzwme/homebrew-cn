class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.21.6.tar.gz"
  sha256 "355e282833bd3115eda156dabfd7df58baa8642f8908a8e5ba35a8e276ada698"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35c0c0023b9d58ef580b2a5c8bd16c3a7eb48079553d79b99de3add3ecbcac89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a0936339f6c321977df829cbd5296f95bd1b85e515c4400f8c6f2b3ceaaa4c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce886663c04b54a2188bf5b2e3cc0f346231735d739f1baa0af4b7276fe3b1f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "58acaca43f9e501c21b1a039047a7729806d349836ce8a879e2f43c34f29da84"
    sha256 cellar: :any_skip_relocation, ventura:       "74da95e6b109edb034c11701d6a79878db104b1d4f4e3bf872aa0f2216d6f58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecd234285b228369062078e21cf9e586d490a3317197ecaf01443c7f5856f2e2"
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