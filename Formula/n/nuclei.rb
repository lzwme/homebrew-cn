class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://ghproxy.com/https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "b31c67587e02bd7301c314d3f1578a7e45a1097eb22525755329d9fc2b6d9f96"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc404803e57c71675c169985132c2ff410341d8da1597775ac51b4f0c12dcbeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7f3b39b8546328e543854679e536702d1b100e403f9652352e18d320d22b88b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c67142e456e81956e568b52d4ea1f2ee611a1ac52a53ca569d2d3fa0532f0da"
    sha256 cellar: :any_skip_relocation, sonoma:         "117cc5547bdcf837bca1a5ba03c61f4b8741dc26ce7a035ae54aa5277f693ed9"
    sha256 cellar: :any_skip_relocation, ventura:        "dde9ca88189ae006e3f0ae92b94507a42a519c0cf3788577af446c7aae1ca7d6"
    sha256 cellar: :any_skip_relocation, monterey:       "480e074694d3902dd6344df28930b85d8b7c9074465651bd6a6694a61b182574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09eafe1feb4e08c391aa9984dc62ebb2fa49aa348cbcd19f7d19334c25c4e51f"
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