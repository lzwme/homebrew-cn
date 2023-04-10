class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://ghproxy.com/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "528c302498e403c54090f1fc154c086ba6f340d7a8f308a492a7b425276554d3"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49e6476d9eb21130bbf59287d04ac18209e5399a6bba1eca4185b9e83a381092"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "472344e7371dc1893931c0fbcf6812cba3de81e98e17208d276953fad7a470e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e1e8d77c09ef39ffd92f218aa052db89bc19a9c8c435f600c9950f928d88aae"
    sha256 cellar: :any_skip_relocation, ventura:        "f74e444618a8ed7bd4f2e57ed39a94db073c2503688f064018db5bb6de3a2280"
    sha256 cellar: :any_skip_relocation, monterey:       "b23484a3117a482e71939ef77d66d95c8d063734e82bf9665d33616abb58d314"
    sha256 cellar: :any_skip_relocation, big_sur:        "7642161a0208476fddd3dbdb3e1fa02fa98f7eac1890744e249f5e9276be4506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "863e8fa9c238fd41f1cee6f8c41cfe7a122d85dbde3bb62659d5a5ac58f10fee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end