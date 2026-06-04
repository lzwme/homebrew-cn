class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghfast.top/https://github.com/kumahq/kuma/archive/refs/tags/v2.13.7.tar.gz"
  sha256 "a2f559d68b14a134e7384ef19bd58a3125530ecb878228eb6144d7dd3bb7a0a5"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbe00295a45d33609c9c67798a23e8768a6815ce84ae27aa86aaee51060688f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40e73b544db02269235d7f74dfb8f1a20b795d6b9b7430e11a774740a3c5fcaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32067c550554e38f068ab0bb3469d4a3ac1d9b26a01d01fec9b643e57af54c74"
    sha256 cellar: :any_skip_relocation, sonoma:        "1372c61dd11f3e1b07332b46d7db8b1fec28d81def8bc3cd992d156f96c82731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a63c042f24f19027b096a8920f85b0bacbff8a9288756d4d9a057833fe142fac"
    sha256 cellar: :any,                 x86_64_linux:  "73926ecaf2233cb358cf18dcba4d9cb070369279ab02eebaeab83d71d9277f31"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/v2/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end