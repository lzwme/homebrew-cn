class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghfast.top/https://github.com/kumahq/kuma/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "96851fe364a216717ad48d9fecacbefd2c76078971e7d738050d21cd4cb5466f"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20f38c42e52a438b8f3be35b2446df7ee7c2f919bd8ce913a5c82e8976616901"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ede905e548c2aa90737c3a7134b9c890c61cb25fda22be12fceff5415fca385"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50c5a0db85a544b33513d7865592f2690ffe6f8c8567cb358e437598c4ef1c08"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a644532d3703d2259c410535f72a84f604baabb70ca831b7a7912c6ab767c10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8215b1aa6c1025faaa45b2c67edec7276998c643c402bb5ab1accc6cbcf9493"
    sha256 cellar: :any,                 x86_64_linux:  "19b768dfccaa22e23c242bd05230d20d252864a49935bbaff7b5e9e238e132b8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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