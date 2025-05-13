class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https:github.comwerfnelm"
  url "https:github.comwerfnelmarchiverefstagsv1.3.0.tar.gz"
  sha256 "23b413b2e302b2b6a0dd6a8585bfc118d45c2bc39a32400cf7c1f02c87b7a7b8"
  license "Apache-2.0"
  head "https:github.comwerfnelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df3f415784e86879b772f1c507394efcdd2d062b4a43989a23557033b0859fc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42d9ed91c8b810a7b2d5a93b84bbb6faddd5a81f0469722628e9608fce92c4d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bbae29c670e94f293d9088c494e33bd1e9ad7d6c5bef0d1d479a5045c303b48"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a5e472669cc7fbe2dae0c120790e0112d4aa0b98c74d0ecb9b65be66b1b3dec"
    sha256 cellar: :any_skip_relocation, ventura:       "d8fe1f940454c3a1623c52a05f59a1dc84aa700e0f0a3913b711240e68b9dd41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfe86071d6f809f6982f49a9f92f1ca429704a79b22f10caa5d3fea5a3bf8527"
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