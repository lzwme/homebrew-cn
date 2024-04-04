class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.2.3.tar.gz"
  sha256 "c3775afe13ca11d5640098b23d3725ab9e325872ce4c812b6c7acf6f96d2193b"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6b148aabf08788089b8273d127abe87e6b3797d2c4d2d7c076e5eb4d0dcdcb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "278ddfb5a55b867db3c37be98b6e1c2f8778da79fb18f3bd109c97b40097d176"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb247ec495eccde02f3c14255ca45c8a9e7ef7c9add3276dccfa3931568497c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ab48c917f6be7a3d30fae7c9b4ae8b52be2a2581ed24260416ddb4a963a5a97"
    sha256 cellar: :any_skip_relocation, ventura:        "02310472e57deadbd61058280017623a16ddfd6fc3c4f5623b549a5aa4f92684"
    sha256 cellar: :any_skip_relocation, monterey:       "0107d678e40adb9562a8603bbffa4903d84cb57367254f2fd02c87e7c3a5fd78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c143a4c82b6640c18411226769a7922a8421459c93f599cce60fa65ca9303dbe"
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