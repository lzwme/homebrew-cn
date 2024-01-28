require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.13.1.tar.gz"
  sha256 "a6d7a8b654a06c999f18f6ab3c01c40a1f7ea41df1eab588e14eb6a534ef4718"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce5465e9c2456d23780cdbadbb863d98451a2e0d8b35506782ae4e1b9654bf99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a516223224d0b14f3f55a4cf469da6e87c2b2ebf04575b2dc76f65bbff72fc86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42e12141d3468157da721bd75a7ced6835f33fc83de12b5ccfca76b886adf1ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "1807170b4a9e9414e8a8b157cfeb94c786b06354b0f43f4ba906a7366bba9483"
    sha256 cellar: :any_skip_relocation, ventura:        "5239e908c6b0410b1399fe66b69b8675f1bc990aafa493cc44c08ba75dc454fb"
    sha256 cellar: :any_skip_relocation, monterey:       "78f2329fc6d7cc3cc0e733e13485ed7b3778aee6376c637749489c72c46d9c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d870b34587fa4c3f3d805a49f33b99768525642dadc5dce0023d47d6ca13e3c0"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.comaxllentmailpitconfig.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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