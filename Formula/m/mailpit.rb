class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.21.7.tar.gz"
  sha256 "65f7c66aa8ddfd8a2a55d6eadb3d1f40aabee5fcb287d3ebcdb60753a7e6e4db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e2c957e828dc8906f79c507d274e0ce3fba9ee47d01e572356259a2621fd56c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb8b130821b0bed73e3396bae3207533a3df75d9a454b12f02c76fd507e5ec4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b495476e89b160bf8663a23f857b04d9da5c6654f7f500bceb500a4598a6e2f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c89fc64bead5985abad70e1fcbc1ececcb491fe99f53ca471f2ecd5e7a90aec"
    sha256 cellar: :any_skip_relocation, ventura:       "5283f40c04f86dcaef02738865a329e96280948bc328806aee4db83b477a8daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "910bbfa778e7bfabeefeca9c701ccae377198594314df23cf91678ba61077285"
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