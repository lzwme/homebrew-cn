class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.20.4.tar.gz"
  sha256 "2b73fedb8bae5f1fff8a06c01a78d358ec609c42560d4a77c3b11e68177985c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "318d6f8d6942af514f04443e0f84973daab5733160a6b2df6a820878e657d88f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4fe573912ba4a6a29a291d052f387fb864d3d8c255d9d174b29a08a3d3acd19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f5cf775dd20e5f205bc8da037384b86a10b8dd26dd3230defb6b9c94c12293b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb2ad93a6d3c89e7c7e8cc635b7fafcedd9cc32dfa4bd620ab826bd4dea8bab1"
    sha256 cellar: :any_skip_relocation, sonoma:         "fce6f9d0bbf86ee7f06826b7338807a7c9a5558412e0a44dc75829cd0c145e27"
    sha256 cellar: :any_skip_relocation, ventura:        "af5c0788d16ae4897e3c702eb9d85a5f028b6853843df44e79b7c7ed9ad89739"
    sha256 cellar: :any_skip_relocation, monterey:       "b2a64d9d2e0e07927ac1274b6272375693f7096d45098d890d7c5d5ad3135568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e116cfaa7f64b6b836ed852a9c5e65e0126fcabc9bcb6ebbc2101fabc82da76"
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