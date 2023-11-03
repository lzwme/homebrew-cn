class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://ghproxy.com/https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "eb0d21a1368836b3364e67d3bfba392e5bd4dd271c3ad15d78abd256337119b9"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e272b74e2090e465c72cb2efbd39105020fae2807011487307b84c950426e34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f1dd30f26223d6e6fdcb711391c1bd8b65ee72a79c59cdbf28f73960523feea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fbc8f4c68f4f038d8dbb3e45e732a96b39353ed37e5919c38149e79f9288ddd"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfe5424249aa40ff0d10949dca6c58be91a3dddbcd448f3d44a3f8e89d6bc8ef"
    sha256 cellar: :any_skip_relocation, ventura:        "2c4e26ada25cfab1d541098fa06eb5af2d924440252ce2d0e523dbae346b4d22"
    sha256 cellar: :any_skip_relocation, monterey:       "027bb6088f12f590e5de903eb3467745c75e5a652c151da3db7ea504584831c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4719fee8b2741c33ccd9f9535d349d092dd8e07187c95d29c3dc51905ca5b3ff"
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