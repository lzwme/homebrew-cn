require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.18.3.tar.gz"
  sha256 "bb05c38595a840577d1727ee2a734dbbabe279fbdbab5be570ba46f2d4179470"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32193115fbf589ad31a7a4f8a417d38df99cbd2cecea238d80e260626d16130f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e898435edbee89f125f35651a31929ee5396ba69704d145e190bec2344eac7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a55441795d3d8a824db71fe89fbb0e7714da159965f5bf12f61faac139cd5a86"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdcb0211d9021e78bd5709949897b8566fc477b36d2851b396ed609b34b14dc8"
    sha256 cellar: :any_skip_relocation, ventura:        "12512e08b266fb10787a23fcb1a6d47e79eaf41b01560c5a39b3762d122874e3"
    sha256 cellar: :any_skip_relocation, monterey:       "71d873f84b905a6a73ccf5e92729220ad28f60de9b44ea9a3bf26042d73c6c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2b73b976dc40540023453f32e3227243bc34d246039f09a39e609f9603e32a0"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
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