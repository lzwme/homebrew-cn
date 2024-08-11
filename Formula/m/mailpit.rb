class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.20.1.tar.gz"
  sha256 "5aae3ff63ac9af3e4f25242b4cb3656a94722933223121a45634fdfbb3ae3814"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af9226e0f114df43b9e29e36f4229f087bca45f0615ad123e2d90d681067ba7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e00727750d88c9f6fcc531a60aad25f0dc4ed900cab7c008279245868f74b0cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "096753eaf9962b90349261860c8138909cb91bfd9ce18361347d067758ec035c"
    sha256 cellar: :any_skip_relocation, sonoma:         "48c29215bfa4246d8cc74e34f035c43d756e2ee721450f2874c04405171eb1bb"
    sha256 cellar: :any_skip_relocation, ventura:        "ece4d032d2040a298a08529e4f1085c055d6388702edb9bc62ecf0331f6979df"
    sha256 cellar: :any_skip_relocation, monterey:       "24c7db42f265b6b7ff38aae3e53039cbe70663b2e767d0e96d45e726c8d63fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4c1ef19374ae32d23bb4154fdd5b1a1d3d79334dd3ff824d72c0d13784ae6c5"
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