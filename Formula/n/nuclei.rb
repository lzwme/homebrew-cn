class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://ghfast.top/https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.4.9.tar.gz"
  sha256 "2e5dd732524ffac0a90dd5fc0a5a33cf95102b73690edeaa30f9d0f63054fc22"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8b1927f4e0a57ba6f44fc9b7967de2c99508d7693e84bbe3456d6355e2d3ade"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de657527dad128750c6116111cbb05d5ff9d8a10c6a0fd19035fb9205b9dc76a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b033cf6aa240e180faa4d2fb6c727c3c837b6862fe008fec55ab61c25beded9"
    sha256 cellar: :any_skip_relocation, sonoma:        "16c047234c69535c9d4f8fb31b12ab94057d68c72e482da55df231ad28e9fd63"
    sha256 cellar: :any_skip_relocation, ventura:       "e77fb63262f7e8ef96c5fc37e38cc9c721c1f2d98f0bd92b3b702781d192b1e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15cd3f15c7aeef7d4e9f3a934c802ee131998fcc86067f7619650c9ef9e7d74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d337dc17ad02c59dbc3b1d224e5694bc625c36c694a48c00f9880f3dec0ba153"
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