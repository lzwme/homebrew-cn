class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.24.0.tar.gz"
  sha256 "5ef3659ea601f63ea7327650bddb40c6f0241d272f2dd832935c88b6d6eb5fcc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2670e593ae89e4b3a23686f64de40f9ec88380df952330411abe325475b941c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25b01c00cc28615723b1b4267e0866521b4c3477f318c17ae35c0be098d89aa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58d72c50fb9be53a9d047bf346d4807dd16e15caaa56c443ba820d803f2b2112"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb9a8154c69839094c3906c1cf62546db4e4db87e340b9d10a2fdc9ee48274c9"
    sha256 cellar: :any_skip_relocation, ventura:       "e7fd07874e8321be5ebfee30f482d03ad566b79eb95e746ecaf4305d3c8d6a6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1327a125ebc40ac7c75cef997ef4ec9ecdfbad92ea4222c38763f6101d649b95"
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