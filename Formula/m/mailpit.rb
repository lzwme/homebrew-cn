class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.20.0.tar.gz"
  sha256 "4b62ef47543db5a9c2ab39dd44eeffc46848883791c1344cf5a272eacaa95625"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "141fee1ba03302698b35ad92fa21dc1bc7d7b0ebcf92e4f4bdb200f2f8e8ebc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3606c0376ef10d1dc2f3ca36a98fc9eb10c8af3c2976e9317050ca5a43fd2d9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60ce464ec7ef8b957bf96b3eb8a26bc46af04cad6cbedf86ef4aa4e80d5e4bed"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb82b40c72217863a4a93e903be4f41e5a013444d3773a2322dbf134c7361222"
    sha256 cellar: :any_skip_relocation, ventura:        "49fbfbabfcca51afe7b266079085f334dcade100f057b5d2856a2321954dc2e3"
    sha256 cellar: :any_skip_relocation, monterey:       "0a4d00fac167cfa2342b6cb99dda7c30f4ef03891a8f9c2a58e8f1bab4cd7983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "302d4a23922c14e9c2628bab12492b879017c68676277e212a3a29b8b2034699"
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