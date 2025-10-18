class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghfast.top/https://github.com/kumahq/kuma/archive/refs/tags/2.12.1.tar.gz"
  sha256 "6ecf2f7bcddd907feccebc1f1ff01d38a55fef60ae6c2284e16ce31d864404e0"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3feb5fe51666e8c1596d272298accc8ae42ee6ea4d1e9333de5275746bd3708d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d86d6ec88accf1ec286a3379bce50baf29b7a15e8f797ddac0ca1eacaed8528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e6daaf3e08e203566ffc41c0bbcb59336e0244cbd73bf2744eb9a0819edd217"
    sha256 cellar: :any_skip_relocation, sonoma:        "061944ccf05cc795ec3a70d030b38eb8f7ce29da5dd981fc0bf59314753213be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c42b1cd66d672f481dc7a738ad65740adae227049e89499761a2372b54898ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21a9c7fa330986aef2359a7307e9d089f65fe12e38983ac0e125b849b1b2e785"
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