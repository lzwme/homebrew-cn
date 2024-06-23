require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.18.7.tar.gz"
  sha256 "bf7232c10f3d44072f218decb43ab91a1fb5ad59eeda4212967c3ca6a2010a67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3048bd9ca84863b2a3bb74c6806afb1c5bc1c9458b3517bdffe38da2022be2d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24fa10cadd80fa12dec3595c30b76744ffd97491f3c5db984454d058356dadd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85cb61b4e3b33c89e3529c842fa3232d2fe3d4bbb954a515d04b906037387e05"
    sha256 cellar: :any_skip_relocation, sonoma:         "21b1c5d06a7bb352b7e74b1bb32e6de71a4fa257367be9ed89b787b7fa1d6170"
    sha256 cellar: :any_skip_relocation, ventura:        "cad9505cbdaf736e33925d7cf544a881735563e0631ff34d7242f0f3ba58dadd"
    sha256 cellar: :any_skip_relocation, monterey:       "5b9d6af0989f932e79427b1777361a1bc4bc8b26df60eaa1e5903779e7cecb9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "263fab07e3168acf2eedbc497b606e615a82113eb76ee15cfdc3705694063e23"
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