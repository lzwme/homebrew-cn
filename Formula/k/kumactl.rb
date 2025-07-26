class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghfast.top/https://github.com/kumahq/kuma/archive/refs/tags/2.11.3.tar.gz"
  sha256 "f55b180eb0f445894350b84a15b1432e84f47075b04f5336b7bf2ece0a579e36"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a1005f086dd3ee68f65b5318cadd36270f3d01270d0e9bd00cf760be1a400ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f12b9a7fb1c0662fe17bd103d6424ba5e906bdf0d12d4b2ded1012111b9fc8aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63a27a6ae9a3f22d88a450d5bcc41254b5a724dfb860aeb840d95a0eeee61a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d686141cde49ef25fa1581ec7f4404d16f4cd8cc5fcd70173907705abcf885c8"
    sha256 cellar: :any_skip_relocation, ventura:       "4962e7a2b76edf876d7fa95d8e115d359222f7e8f2879248976c1e03778d3f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d5c408ea0ffe30f56eef2402651cc5e6c8dc058acfa982466532983b2a45c80"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end