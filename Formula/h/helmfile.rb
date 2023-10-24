class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghproxy.com/https://github.com/helmfile/helmfile/archive/refs/tags/v0.158.0.tar.gz"
  sha256 "9c31c506ae802ed0bcabe83218f114861269321fac257f238cedc6c209ff13aa"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "056c9b1c44b4459c573f90b47f916a35fc2127d661cc20c8a1f5f62aea708b78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8248da27c7cba702bdc40a2d125b71142cd19635fe9c3c2ba9578d40557cedf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f923b8417ad55a7af8eb42bfd31d1a998b9428450cf8e2fe00eeac72fe1ec836"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd7d85ea47fd0f655671f76ce1841db4598108bdc80b1fb147ce430d5524f453"
    sha256 cellar: :any_skip_relocation, ventura:        "227e565073ea96802fda46ea2707e9ea26b583df66e96c5f9600f0d75d50e5f3"
    sha256 cellar: :any_skip_relocation, monterey:       "2dc421ec9aa4565917534ccfb88290b9f5538d062ae52f24c0fdba3118d8a99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d455dde885131c3485604390dbda544fa2acedd41e48813c8dcd99e5c93b1e2e"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"helmfile", "completion")
  end

  test do
    (testpath/"helmfile.yaml").write <<~EOS
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
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end