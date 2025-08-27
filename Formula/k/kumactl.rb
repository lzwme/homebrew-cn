class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghfast.top/https://github.com/kumahq/kuma/archive/refs/tags/2.11.5.tar.gz"
  sha256 "1ba7982c036526cc7cf3e42fd65282d86af95b2c2cacd5b913ec81dcff4ec924"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "380c67b50f9a56043d3d39a78fbbb6feef0522240991f4818d32c8ad7d9e3125"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46bf83a8c05210bf5fd5ea55b6561e3c5aaa56079bb7a64fe97fd7964277d345"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51f3199c78072adea3741cb5b2600a60745ca203c7916979269f955b00246542"
    sha256 cellar: :any_skip_relocation, sonoma:        "143df9fcbf43c607ce7907f7d7a01e509097c850bdff536d4b309c97a5e2f15f"
    sha256 cellar: :any_skip_relocation, ventura:       "a9208b7d4bf27afe69d7f0d6f3abf35c337ae3bdb92e40d68faf2a3717dd8de3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0760ea16ef64a44d17afef4da232011ff698de527aba579d2cf58fc3e5abbb6d"
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