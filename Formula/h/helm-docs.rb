class HelmDocs < Formula
  desc "Tool for automatically generating markdown documentation for helm charts"
  homepage "https:github.comnorwoodjhelm-docs"
  url "https:github.comnorwoodjhelm-docsarchiverefstags1.14.0.tar.gz"
  sha256 "65386a0c6401486d135a7c436b28fd1e9b8d0232bc2c702f8c7406a1139aa54a"
  license "GPL-3.0-or-later"

  # This repository originally used a date-based version format like `19.0110`
  # (from 2019-01-10) instead of the newer `v1.2.3` format. The regex below
  # avoids tags using the older version format, as they will be treated as
  # newer until version 20.x.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d{1,3})(?:\.\d)*)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b2c53928925eae9f19d20b0912ca6e65669a6f4aea0072cdde49115ecc60b37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9932d8a6f935a341c99838d2cf55962608136850790ab777276b4614752bc8ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06d6a8887470d6659c83593b17ad858581aba3b4cf00a90b354ba06280a5cfda"
    sha256 cellar: :any_skip_relocation, sonoma:         "62a07c0ed09269214fd203bf921957623fa96c352bd0b208ce086f7b5d48afc0"
    sha256 cellar: :any_skip_relocation, ventura:        "80fc1daa00c2d42586e91140cff724042394aa990b280768808c13c208c4627b"
    sha256 cellar: :any_skip_relocation, monterey:       "8542bc685ddaa2361b52fafad0584bee6c6e4aef4e32a66656300f2f8c9dd18e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b82e35467e5145808747ea4ef21c4ff637e710325a2fb2598157d97f6481203"
  end

  depends_on "go" => :build

  # patch go version, upstream pr ref, https:github.comnorwoodjhelm-docspull247
  patch do
    url "https:github.comnorwoodjhelm-docscommit0b634309511c595c50b32d3a3090c45fa5a4cd2e.patch?full_index=1"
    sha256 "6607867eb63efb3e67a42a704f37615277f4638f167cbfdd697d35a335710b0a"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdhelm-docs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}helm-docs --version")

    (testpath"Chart.yaml").write <<~EOS
      apiVersion: v2
      name: test-app
      description: A test Helm chart
      version: 0.1.0
      type: application
    EOS

    (testpath"values.yaml").write <<~EOS
      replicaCount: 1
      image: "nginx:1.19.10"
      service:
        type: ClusterIP
        port: 80
    EOS

    output = shell_output("#{bin}helm-docs --chart-search-root . 2>&1")
    assert_match "Generating README Documentation for chart .", output
    assert_match "A test Helm chart", (testpath"README.md").read
  end
end