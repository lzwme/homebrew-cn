class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.1.4.tar.gz"
  sha256 "ed6a591de3db688091123cc5ffebfe2b1fc0f888897508514a77f648fb8d2459"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e37ded0074cbc1dd85ef19c2eaf637680b8ef5747d6e1b2da31f60cddd7d575"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0b464f3b61e1733729585c1882cfa9694a818811e590b574ad1d615c583cc03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c7b3beeccd99e2acfbbc431cdbb8a540fc95f505d131bd05d89c6553fb966c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fa04edcf97511bac2a51dd81187a975cab879f7dfdd494865b5894b5a04c491"
    sha256 cellar: :any_skip_relocation, ventura:        "035a38338bdad3e02bcce5fa3fb7be35f0b19c19b0dbbba8a368e99323f4f885"
    sha256 cellar: :any_skip_relocation, monterey:       "836732844a3b21e8784e7a492ac70780fe492df9b17de2a1f5543ee2e9a84943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6591f1119e0b341978b381641edc73faffbb904fe8fa53609be3c9d2afb56bef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdnuclei"
  end

  test do
    output = shell_output("#{bin}nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}nuclei -version 2>&1")
  end
end