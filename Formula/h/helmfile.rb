class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "3e5d6fe03cd31aa76fdea5703abf36af4fbc4420a64da450f232d2ee65b5ac98"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0543283159b16dce8271ad620e986ec31c14510fb50ee9ddcdaec2f9b8e7e036"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "759a555776f1bc3b919aa7e32ba3ffab6a20e1ca559d6ff6d582bb4fb5a15a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15f24407d69edf1ddd2569a4268f4cce2dd263700a6384594424d97e06938c90"
    sha256 cellar: :any_skip_relocation, sonoma:        "8616b281516afa4bc0ec34633ad735f0f007befb803605f079ba642c9d809c0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a2751c20c06eaa59ab37e68e2ac6f7d84112ebe6e450c673a506c64a19fd79"
    sha256 cellar: :any,                 x86_64_linux:  "191a3dd517d00d4dccbdce80bce2b6a82ce3c6083cfe256fe1ef9c7722c2ca5b"
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