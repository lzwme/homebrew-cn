class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "87cff2184695132fca3803fc2c8853ebe812e6e5a854f1f58272ee476afcf8c8"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e94e04aa3402187d4a02e8b39323c7123cf1f836d08b01e4986c6da8025d8a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af47a69e04d15e8b9874f41a4390022c70db843fef6e91ed72c03cda3bc1f0ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76b1eedde9427e1ec9ff919a4e9060e0cfe798d5b23455448814eedea6b2c170"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb8047cf98779fe26042a736b2433f697ee005d233fd22b271dd8b45b05b8a8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dab290eee6dc22ce63ddfa0466d16eaac88b2ede3cbaac1a4a0b059ecf7feab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a18261a61606180e4d6f0c59c8ce001ca89387c4ec56ae99d44b0f474139d5cc"
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

    generate_completions_from_executable(bin/"helmfile", "completion")
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
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end