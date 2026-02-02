class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "249489405815b99f6318abea2c137a0fd34c3f86c2ee171654342a64a580a7f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e886093f84e2ea808eaef235f33142e5ddd55fce037ea640e0d1a82ed5764ec0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd2dc05d2517111f7eb3caa4a7fbf3338f97d75156250f661d8ca7015e1fa608"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2850814cb116776f25ba0b9f13b72c60541a32cf631cdaf21afe732df483ff5"
    sha256 cellar: :any_skip_relocation, sonoma:        "468ae825796969c1e8ec90224756899b7621ba04fb4e8ae59cc669e0c79d6aa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1f9ee2c697dd826de6b8ede6316e9ccf4877302c092dc81e7d2c33b65970fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45484b319f60fad320f629a36038541dc09415d757720f3cd80b65174922b49"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", shell_parameter_format: :cobra)
  end

  service do
    run opt_bin/"mailpit"
    keep_alive true
    log_path var/"log/mailpit.log"
    error_log_path var/"log/mailpit.log"
  end

  test do
    (testpath/"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}/mailpit sendmail < #{testpath}/test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version")
  end
end