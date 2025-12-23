class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghfast.top/https://github.com/kumahq/kuma/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "8db6ac377577a20711447f405b5712191c0bfb822d418280d31e98cee3c10b6a"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1519e1a021b36aee14c7acc315f6bd9281d945e877b5e28efeb67a499d2befe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0620976ec1cf04b7da25c1645e9bbd60bfe7d400481d840c9ce3879939782a71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92c427e4ad52667a5d33231f682bc600ce4a09a3aa33844b9a846d694867359d"
    sha256 cellar: :any_skip_relocation, sonoma:        "472ce6028f335a50a0dd05c048eafeb986d0d6d39617f2835ea4229abad37dcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44463299261868482df2bcaa795ef6f92b5418625af008aab0a0199acaa1441e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb7b83820900b16516c8d45d674ab81620c2ef32ac47353aff5698f57b6afd17"
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