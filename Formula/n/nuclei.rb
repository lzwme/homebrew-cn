class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://ghproxy.com/https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "0e2497d814fc33f75f618e4e7e7faa903f6137fd18cc55e16cdd0ff77eb2a141"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e9d2c18cf60053f891369bbb1f16ca417962be55962738233c2bbf067195417"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dab7ae3efa9171b0e4b7edd7dc8de40f3da092e0ac74667a9e46f3050454192"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "258463ca2a2baf65ebd6e977693d3254c3948b587d2b253c27b28a53f049fe85"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e7d2cc57eeaadbc4c570e3bf974a8f6608a5986e2027b90f70a81698347b2a7"
    sha256 cellar: :any_skip_relocation, ventura:        "9df225b545e66d0a7cb546b6c28d0f017b4a5d5659693409ed734587c5ef14f4"
    sha256 cellar: :any_skip_relocation, monterey:       "e460339ec37dae09ffbd9233bd82c985b3528ede91b72772144d2d90bbf09f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd5b6694903cebcdd9441c5cad2e4596bdc9447d67df8904ef934128928c70dc"
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