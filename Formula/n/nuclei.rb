class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://ghproxy.com/https://github.com/projectdiscovery/nuclei/archive/v3.0.0.tar.gz"
  sha256 "81088d5fb7dc6be1ab1c27bdd97230834e7daf0c901d1fde114bfe378989066a"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28837d415f030e3ab36cf907deef7d338b3c91c5c56e38bef5acefc337b740e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d68618e5de35e909a858628a4389ffae142dd6bc7b7cee9a45f9f181f73975fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c56b5b997fe588b9a97ff812ea9843f0b0e382492cdb7bfd4585b8cdb63a3372"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffad0e8b61122d6d0d4e5aafa284089e64fdafd5d95ab4eb4e4c52b8a006e68e"
    sha256 cellar: :any_skip_relocation, ventura:        "2917b4acb7551225356fd17f93b74dd378bafbf3dc1933cba38ba23888a7ec6c"
    sha256 cellar: :any_skip_relocation, monterey:       "56843c36c9a9ea28adadf262603135cd4172d50ac92a990eb5fac7d55b3e052d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f8d7aadf456e0a3c7f965ed2a66a3eed69c3c89b8fdcbe4babfd283325494f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end