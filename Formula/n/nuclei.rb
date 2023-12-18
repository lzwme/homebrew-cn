class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.1.2.tar.gz"
  sha256 "8b0acdbb586d49286de8dd73f41cc228a2613a1ac3a467266fa247930402bf80"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8380be47eb3b84659b5f37fa881f238a18217ba215d43a807a3664d6a59e4108"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35319077891dfc6bd1daab4bb2533baadb0f127d1881e6f1a01f7c851ad86f01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c54d9ac1a7643e7a76af79b48a67f3b13830e658c47da408c52f33e904518acf"
    sha256 cellar: :any_skip_relocation, sonoma:         "9009c39180b77fc3795a324babf7b5f662bc3bf77094a5dfbef2feedf480f98e"
    sha256 cellar: :any_skip_relocation, ventura:        "2e53bb1535a1733a63b1a60ae3cc179ccdae0e0560d0aadfb54a114f8322a939"
    sha256 cellar: :any_skip_relocation, monterey:       "150746d23b8612160a0b34939809eb4e9ca6065aa2df9eabac3c2fd5be5cc2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b9ffd7108d270782c40e48d5924fe0997ba20ec95a0d96afcea3ff50013ff09"
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