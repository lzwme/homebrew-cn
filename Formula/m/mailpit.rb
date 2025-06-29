class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.27.0.tar.gz"
  sha256 "1c751e760a9f1be44ce4f5789067ff9596fad299539dc14c4e5a7e704364376a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "473c194a46d89fbb0077fc73baae23707925b621e1f4516ecd022fb77c6b83fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24911e1239eee470ed64a7621ed9f5b07c03f5ffbf9e5681867c8605bbb629d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b23538cd335f843fd837ea77386379debe9fdf486ccd8014db82df3ac34d7759"
    sha256 cellar: :any_skip_relocation, sonoma:        "118f501efd19b8f806100152283691fb77b883b6157cd7ed073febcd02a76ab5"
    sha256 cellar: :any_skip_relocation, ventura:       "7a205e22675489eec72a19ea3a4746817951f6b841c721fbff52a369b053f378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f51f5c5542d5af512c05e33d1c0aca99ef3034d2a87f7e4a3c5f9854e39b4011"
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