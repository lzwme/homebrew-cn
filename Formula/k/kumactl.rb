class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghfast.top/https://github.com/kumahq/kuma/archive/refs/tags/2.12.2.tar.gz"
  sha256 "547698067420d8a9918567d0b93b3da4b875ee0d78314ba1654f059bc4697919"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5c579a8ebcc0ece57228c48f291c4889744af96230764c60dffe072e21425c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d40c22f4da4dd9f545527e62766c14085d1d7aa41c94aabd875734f7a1f7f398"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23ae6eab1d943e93f8b4852d77afae0acdf1ebc96e7aa875e854fa0181bc94b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd3715599e6b9381617ae4cace65786d3c73c79a9d9f47291765276cd5abab34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e75451246b2b3f6cfeb481e181ac2eb19905f62eb3b44c0b19d6644af8ac0d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d624a6e699d381b4d932c241ca70b2c280851731217bc2e55b66208dab11b36"
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