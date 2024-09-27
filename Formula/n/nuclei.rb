class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.3.3.tar.gz"
  sha256 "f4a91edf3c893b9fa7aecd6c3c60fbcc4165459fcf3eaa9483d3ce555d62a34a"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83ce23ab99aaa0f5d317747b28356352caf6bbd4d5b7506d5c124c72e0822d42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1842ca3179582339501d64247148bf2d1a6613900dcfc8d182b0da468b81815"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55f040a0c3b1fca7f6860ed896d012572a8daabd486070fa51c007d1bdb0ed60"
    sha256 cellar: :any_skip_relocation, sonoma:        "85b88b6d25a8b2201db953f6111c9e1ea93870738501187b32b2756fa888faca"
    sha256 cellar: :any_skip_relocation, ventura:       "7ce4183c58c6855d15365aaee7e4ba2e1ca0da116526a7f8da4a8b4b973b64ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52c2e9947e14633a670ba44ad740d7e7526ccfe21a884e7b324c3aa420578df7"
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