class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "1bb6a7fe9b85732523b4989b1503528c71de84864991e96ff855baa84062986b"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a7daed5b5d2fa54eca624232315b90f745647d260ec9d8010f9b154b2d24bc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36ed5fafc4b57bc110390fc5e219d791f117a09238cbfaf32c369c8d0215ce8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0ef7370e26eafd9fee029b3e3169995b3462dc95721609c5ef14705137c5e50"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fc794bf392871dd8e9594b8d39ff8528fcdf2e77954ccea2058859241d55ee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02ac55189be8e9e312a4a83c8b615fcc9aed7262b461f8f8771301a2dd2f3976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a6124de4b422638403a85a6e8a343f254f487267ea1ce07de9163cbe359f4bb"
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