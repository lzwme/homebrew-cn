class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.5.tar.gz"
  sha256 "5fbf2dc4883385db1fb9e0b48edeb6120d86c6b23b70f76476c5432a0515fdf1"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1b991bff51dd0f5e385bb241f0b9629ae931d98c30ea731ece4dd7f43636c39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5cbef0f22f783bb8078b1800cc1dea07a55fc71fe376696502b900bbd410cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07e8b26e3e635736e7f8b55eb38bbf8325306e8c1e7215d79adfb010d22b093d"
    sha256 cellar: :any_skip_relocation, sonoma:        "57f99718789ea379cdfe439a56f6e0ab946835cd497c64535ef56aec72094249"
    sha256 cellar: :any_skip_relocation, ventura:       "458d4562d7fc6ff101cd0a3792171f2a01d8b48309d7376ef2477fd6821c0ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4717d6325a9afe8115a3a238b20279d02946bcc9a277fd3f5ac03939cefac2d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}cdncheck -i 173.245.48.1232 2>&1")
  end
end