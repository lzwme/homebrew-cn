require "languagenode"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:github.comaxllentmailpit"
  url "https:github.comaxllentmailpitarchiverefstagsv1.13.0.tar.gz"
  sha256 "bbc2b750aefcdd37ee3f0929347bd91f79a6d0c2f4faab63d465ffabf6c41cf3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d989ebf22cc19f83bbaeac6fe8730e58811ef94e5afe84446bf65c31a8ab21f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1df29c4907a627e772997ee101d55310c4f71ed7c50de15d2a490887cb8e45e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3933893f6e08402ce087a139d3f3312f4d7db85bf18cb683a1861fdf7b54d32d"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa24a5cdb71fc679d063e8ce2d10008f0433e0a6d406038efb6c25a3cea0117e"
    sha256 cellar: :any_skip_relocation, ventura:        "5553bf0349f1b15c28ff2b4548ff98eeae502826f98a62255429d96ff28ad666"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3ee7d7f87d2ffe8db553d7c9cb1d49d486b254b4d3f8591f038d33f707e5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a55d07f7a84ed7419a371b930b7f198ffcf6892287f1c33cb42e35c00dab5ef1"
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