class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.1.7.tar.gz"
  sha256 "2a41b97bcfb8018eccdd5ede1914e1eb8085012f4dcc33c3b057dec349e5e42c"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b27c123cf3b14ed2a1b97f5ed7cece6a6ae96ec813c1522715c6afd50378e831"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1674cf91539b66f9c6299d13468e677782722bb0fba00fbea99b3272518236b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eb35f2db031e60245c9eb53759222c283e8abdafb0129bed23bb5a0a207701a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6912108233333899bf828611ff3964bfae3a282efd36cf1cbe1f2844d594c70d"
    sha256 cellar: :any_skip_relocation, ventura:        "a06524699d506b3366e2d91dd3a68f2c888bd23cd3b65dcf432addde73868ddb"
    sha256 cellar: :any_skip_relocation, monterey:       "bb791bf8b9e412e9998c6be0ffd5f1377101a900b305df2ac383c192ff1440ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf0501866da2cdd9eb64621ade47512bc9848d3bc354f970bf1b25a1ea32e877"
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