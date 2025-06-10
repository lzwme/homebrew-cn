class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https:github.comwerfnelm"
  url "https:github.comwerfnelmarchiverefstagsv1.6.0.tar.gz"
  sha256 "ea779e6639ceda003f053ceee40a91c520be668019438b2faa42f83dfcce581c"
  license "Apache-2.0"
  head "https:github.comwerfnelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb80baf986ac5910c4707ee15354bcf1a1b38af2d797be7e6c045903da1bff0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "406bdbb8cd2acfa7e0738851434171f86fb0ba8f90edc79a6cbabdc0b6317781"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "612386d360f82d1bed216863d4c862a1903db14a6db301520ac761c8db5df5fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfb9fa5af7a6c98ed167fa4a81418a07ae627fc0e09fe7898905f564ba93586a"
    sha256 cellar: :any_skip_relocation, ventura:       "2f0a3e6ff2dd23be91269423370cdbe1296609565f6eebd0415924b5bac4eb5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9a3d5bfc1780a2055494679a862faf80a07972c903837ff10d3accb4bb0ec83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4d75f845d3c732eadd734c083ef8432f77cbdb1cb269b1817e15bad1857a3c4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comwerfnelminternalcommon.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdnelm"

    generate_completions_from_executable(bin"nelm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nelm version")

    (testpath"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https:127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}nelm chart dependency download 2>&1", 1)
  end
end