class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https:github.comwerfnelm"
  url "https:github.comwerfnelmarchiverefstagsv1.4.0.tar.gz"
  sha256 "19fae429a70848da726e330ffe48976b20111a73c5a4ad6479f2dd82e26176ff"
  license "Apache-2.0"
  head "https:github.comwerfnelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c36377a0caa9137a815f57826ffd3ddc7e93423c3bdab4297cc05767b640316"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92599f3444e7d4df8935e44b7eca276fa62957a414121f262070c2ebcd2e3360"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8260419b0e66803645057099c7e4b0d847d78179f225c3d818df693e2eb79239"
    sha256 cellar: :any_skip_relocation, sonoma:        "a695fb7343cfb94b0fbd6e54a5b3c77b9c01eb01bca03fa143dad7aaa695deca"
    sha256 cellar: :any_skip_relocation, ventura:       "c240543c746bd7876174e8006167065e101368bcc38025ed687a33df6adc9bad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8062c2e5b4f6d3e7095118301ee654384ddf181f063d61fdd85b1a0d65a30a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c320376a4a1a5827b7e9dd78740d627ad96d411dc1958dadccd4e56cfdf4c143"
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