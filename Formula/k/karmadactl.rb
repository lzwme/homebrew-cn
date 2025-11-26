class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://ghfast.top/https://github.com/karmada-io/karmada/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "f70ef3701ec6ab9711a529970fcdf983ab83558989eea4a3caf539c7486c9455"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "782a8fb21cbae8839cdbf25e121c2abccd0641ba7383af6ff1f204662cdf24d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11d696a478b05cf43fcc60c8e1b92fc32320f596fcbafdecec5d4d4cf7f07445"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbb863c3c915135907b8517c2234a505d2716f9d7ac47dbd941d1c732ff3b5ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "e47bcddaf1de527dec683363b68484cfb6e685444f0182c03e96d9d01e85d3b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ac971f14f032d928d3201f70833211f8fdb2cbd940f82c1f6518a92dc0ca701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02434af126f1f9885cafbb7ed0678ae22f1f516505cebb20e1ebb7896c84a9c"
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

    generate_completions_from_executable(bin/"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end