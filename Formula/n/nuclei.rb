class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://ghfast.top/https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "39cf2e599d6bbfc9b417d1bab224cac5ccffac304651fc16bca3613e517595ae"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7e45b695a673bc653d459ae0917bca960c210bfac5f136016cca05a5a1c74fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9849bc91edc038a78e180bc34d441ca97b452e2f5d8366815b9643db3b3faddd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cc3afc9c00675121e8bd415e0487de48e4029875f8fb112cd353a4a1b1227fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cf8e3d7d55f2b8a2ebcbfb187c2de5fcb25d3a1afdcaa14c8efee07bc5e19d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5c97cbe7aac99cab47dbc5d4693c028b295ac06a126149509586cfabd31c7c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd1096d8efd6ac74bf8b0b2399686c20470111dabd37f0168bbbaa65d3501268"
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