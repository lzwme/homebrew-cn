class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https:github.comhelmfilehelmfile"
  url "https:github.comhelmfilehelmfilearchiverefstagsv1.1.2.tar.gz"
  sha256 "990e30ec57cc1701a6c1265d3e6b7d820ddf93444aea5daf568fe0c220cd46da"
  license "MIT"
  version_scheme 1
  head "https:github.comhelmfilehelmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc2c679cd9a97a6a31c17e511092823d422f2d7ca0a881c2a8cd7fae3a07857b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8b50267f397ea866003f739c0245e7ecb57ec4d19dc24ef9ceeb6beaa66ca2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b453a9f7a963816462cae45e27220749e76fcb4639d76d6267e2d7043c04f68"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6e65b4d484634e9afb365dfdfd0bc114f349c61925104cbf887309d36c632f3"
    sha256 cellar: :any_skip_relocation, ventura:       "07e81393006eb16cd80da2054d0623cc88e712615d0a4320dad1e484c1edfb10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e25e4de9c7520ab19547468395dd8bb7b7c66f81b1bfe0237094e75d24d2d2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c5c44415fb3392ae4cf9b4b93273ef7782c42de0eb585e2750b69051e0df3be"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
      -s -w
      -X go.szostok.ioversion.version=v#{version}
      -X go.szostok.ioversion.buildDate=#{time.iso8601}
      -X go.szostok.ioversion.commit="brew"
      -X go.szostok.ioversion.commitDate=#{time.iso8601}
      -X go.szostok.ioversion.dirtyBuild=false
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"helmfile", "completion")
  end

  test do
    (testpath"helmfile.yaml").write <<~YAML
      repositories:
      - name: stable
        url: https:charts.helm.shstable

      releases:
      - name: vault            # name of this release
        namespace: vault       # target namespace
        createNamespace: true  # helm 3.2+ automatically create release namespace (default true)
        labels:                # Arbitrary key value pairs for filtering releases
          foo: bar
        chart: stablevault    # the chart being installed to create this release, referenced by `repositorychart` syntax
        version: ~1.24.1       # the semver of the chart. range constraint is supported
    YAML
    system Formula["helm"].opt_bin"helm", "create", "foo"
    output = "Adding repo stable https:charts.helm.shstable"
    assert_match output, shell_output("#{bin}helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}helmfile -v")
  end
end