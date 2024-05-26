class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.2.8.tar.gz"
  sha256 "858e8455b3b0698b464c0cac4e6d5b325c34b3546216285d87ec5c6dd982621c"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cae9f3147cb872baedda02af2127bb90fdaa082fc035df59745c3ed614945b3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ea10954233f5ce765fec5029d889d04d55f7dd00ff68e3c20dc14a90f6071d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0d491d1578034bf4ede96b4fb28ca04810c0d8b2fdcf33c6db81e311fa0b424"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa8e5f19b8bf8e98405bf1deb6333c79ed8a408b073798582aaa00101baf8eb6"
    sha256 cellar: :any_skip_relocation, ventura:        "3a563e94ae58365fe9bd9aa6c404b528751e674b1b1dbd0b1353804e61da2ff5"
    sha256 cellar: :any_skip_relocation, monterey:       "b275d4b45aa8837fa5a0c1a5169d93505272fba08778757788dcc281262f6da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "777a068f9ec2754883754ab96ae311d3675633d3c4a960e64cca979fd36234be"
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