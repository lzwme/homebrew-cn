class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://ghfast.top/https://github.com/karmada-io/karmada/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "e472876ea528042838f431ec94a1186b2bf4dc9c8ca3303e26e8830c9e32d83b"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f0c4e07c00c671824cee7ef8f101b54baf849273b1bd6111a29a390a3ac0500"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "581de0f0c3d3878d29ead664a8df318bef238d40dde002ac545076ebdd042247"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2adaa40c8670959623f44472e559a7968bd401f81b361ab7391736ca754f0fa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d32c89ddc5ea728ec16c307fb50608f1deaf4015c6e95ea79ebee1164164fa25"
    sha256 cellar: :any_skip_relocation, ventura:       "77aa4f6168fb108ea7c2473dad41e75f61888ed8f73116d45cc5226ef4d512f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb5060f6ff5aa9cf82dcca31bb8183ae99e781c335fa3ffab9ffa6eff922ce73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b104b1ad7cb5ccbc85c82d412a87f6068b78192fb57dd0dd3004ecc7d2d92e00"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end