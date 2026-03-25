class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "217899641679d77ffabde608f9e35ae4ecd3f179479ed236412215c74fd226e3"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf11175a44b12e88a47913b98b067ab81721706b65c766551808ab7dbf740392"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05718ae9236ea245df7639d08e212587868874c460f224d33d2a77c4f9a7b676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38df126e8de40655cfe4f1ee1c86ebc3f55979b83988c2de9efd8c4d7ec94569"
    sha256 cellar: :any_skip_relocation, sonoma:        "4440df46da9dd5fa3872894bb10043c28365b022c56bc2c120a2d9b60162aeb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d19163f272d31f18d22b729749a7663c7fc3012bda2b1f8df140626ba8c806b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5be6484d604eb59db31a926047f4c65f9e5ffb96e634d6604a9dff5d01cb2b46"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
      -s -w
      -X go.szostok.io/version.version=v#{version}
      -X go.szostok.io/version.buildDate=#{time.iso8601}
      -X go.szostok.io/version.commit="brew"
      -X go.szostok.io/version.commitDate=#{time.iso8601}
      -X go.szostok.io/version.dirtyBuild=false
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"helmfile", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"helmfile.yaml").write <<~YAML
      repositories:
      - name: stable
        url: https://charts.helm.sh/stable

      releases:
      - name: vault            # name of this release
        namespace: vault       # target namespace
        createNamespace: true  # helm 3.2+ automatically create release namespace (default true)
        labels:                # Arbitrary key value pairs for filtering releases
          foo: bar
        chart: stable/vault    # the chart being installed to create this release, referenced by `repository/chart` syntax
        version: ~1.24.1       # the semver of the chart. range constraint is supported
    YAML
    system "helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end