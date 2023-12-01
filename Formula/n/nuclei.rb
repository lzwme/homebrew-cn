class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://ghproxy.com/https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "ea19def4856d7fe2ba444ed5d6797855e0f0773912b3f47f516dc33e654c69a2"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbbcbf578cce853d0f311b037cc16cf8f0894bd25bd86d00a99bfba71155142d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "155f6530405ff91cb118a7f4086ce0fa1842cb019408ef6a9db12ce78615d9d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90dcec65e8230022f1f40ae755e5df21b3b979a07e3cea46479ac504e66c8ad3"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc5d692c1ade5cf605d15fefef60e203cbb08d9ef44b67d6610967a7a8f9a447"
    sha256 cellar: :any_skip_relocation, ventura:        "e6ac8fa2f33936461649f6970e63c09a8418075ee727968f16577c1f4971f5ee"
    sha256 cellar: :any_skip_relocation, monterey:       "f64287275df8cbb78e543e4b64a9d1e2b1a8353d2edc440d08d4d05f7a508df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fdd6fd1ce8e3fa8e838355f3c0c1f53249e10ce81e54f9a8b92a2238af22106"
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