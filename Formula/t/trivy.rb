class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://ghproxy.com/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "ed4c7d62cf651d5fc2fdef6cd208c0f1dfcf6b177971dcc9478415a9394510b8"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb838feae28ce29d14677dac1c61027b22a2c21df21f598c908d66fc77d92038"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6618c8342e3d03e034a71ea1b706e1d9cb2d6ce433e269307544203b499b3570"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d0815b5fdaeefa1c298c47b4323e0804adff4d8d0c6e87ebe5c5e880ab704f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "69268486f457415ac9e6936de3e90c3854495795de0386c96aaa18f64b425577"
    sha256 cellar: :any_skip_relocation, ventura:        "cdab05dadc642e20893d1ae9cdf752abbc7ea5e74fb11d88df5a316e37b42753"
    sha256 cellar: :any_skip_relocation, monterey:       "5756d0da206598a5557e4ef2c414a845db3f82303d8a0d54460c077aea1c7329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d9f8a8ca4549bbf3d4e43bc6f6a926d47551589c18d8ca886d48f88d620a397"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end