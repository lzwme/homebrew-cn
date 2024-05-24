class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https:kyverno.io"
  url "https:github.comkyvernokyvernoarchiverefstagsv1.12.2.tar.gz"
  sha256 "190a860bceb53ce4b54f83048f145bb1250fa71cbc77ba365d044d30ca71b5e1"
  license "Apache-2.0"
  head "https:github.comkyvernokyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa813a466ec06b92cbe3b4712813ab2335129f3d8add23f9019e61b70f6a7a75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d04a6923f2864cb15f051417f77db539eaffd153d4338540b8b24afd34797af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b87ac1078df51ecc5b5b33618ce3f6cb0f666cb9c134a25fec7bc43b21733b78"
    sha256 cellar: :any_skip_relocation, sonoma:         "7158985dbbedbd5139aab8882364a14ddc39ccb01fa4460f3141d531ed07fe76"
    sha256 cellar: :any_skip_relocation, ventura:        "fca4787a0ea13c33ccddd47e64133467f6f574c521658668ce4cfe844cf979ce"
    sha256 cellar: :any_skip_relocation, monterey:       "30550840477020acdfb35138a2bf7171e14651f0f1e76ff944712d203ac41776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "019a4841fa92a63a25786b87627ac030dfa50a1ae95e6696ab9a391c49c81873"
  end

  depends_on "go" => :build

  def install
    project = "github.comkyvernokyverno"
    ldflags = %W[
      -s -w
      -X #{project}pkgversion.BuildVersion=#{version}
      -X #{project}pkgversion.BuildHash=
      -X #{project}pkgversion.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdclikubectl-kyverno"

    generate_completions_from_executable(bin"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}kyverno test .")

    assert_match version.to_s, shell_output("#{bin}kyverno version")
  end
end