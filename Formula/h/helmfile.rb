class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https:github.comhelmfilehelmfile"
  url "https:github.comhelmfilehelmfilearchiverefstagsv0.169.2.tar.gz"
  sha256 "08b19323a38087eed5984ea17642e8934f7c8d9b328597c12256cb461a4eb03e"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08d6c3fded0e8ab0962f9052616d8a05365b0df15a1f912b0d5f080610d9b85a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9c32da63517ac673214fe1b5ac2695ac79c6587683808f5a5d516caa06f983f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb520b5eb632943c5f2805426439e17fb8fdd05368cbbc4475e7436138dec3bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "005c592aa6c4fc1cead8365fb29c948c47f344fc381c416d57dae8aa17b3a3fc"
    sha256 cellar: :any_skip_relocation, ventura:       "7f89fa84e4fcb7f09ca4f28209a304e3dad7f4f786667aaf228491d000b8e89e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e530c1fcb6c871ef07304ffbee45337db43ff2cacfb616c0fa71c1a3e3a43fe2"
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