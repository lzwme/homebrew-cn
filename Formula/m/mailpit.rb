class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.20.3.tar.gz"
  sha256 "2a811cc8f81b84602af50417d9f0a4ae6ae7fffea8d8c98460396a20fed75f3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02991877a12eb576dc749e92c19705fe33d1d70b11a24544d700fac02748a1e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c24e792b69878db2a83c41b9a5594edbaf53cfd61793e339757217644a4ab50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dbed79b0603ddeeb88d0953ed3237fff7a40f3759acdf998e74819821745396"
    sha256 cellar: :any_skip_relocation, sonoma:         "58a10c4d72a8068b0ddf46749f9f69fb9c5322326fb261dd9463b339271b1de0"
    sha256 cellar: :any_skip_relocation, ventura:        "b30c38f397001b6fd6a5909045e138f36f18253512d1f7763e6440c8361e4fb0"
    sha256 cellar: :any_skip_relocation, monterey:       "1c6d9c4a727386f7af32cdb2046bad32d9af2de34f1a38b6ecf14dc5ffcc20f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f969203aecd1368cecb71a11b4b622615c1181ae976cee23e120f625ed6ca73b"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
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