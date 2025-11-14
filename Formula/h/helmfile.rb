class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "e783c93cbe8f7ab114f87fa9118b06939e63e8136c3ffdef0113c45ccbc4c74f"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "665d415287037454daab62849735b3ba6c825b4a6319aaadbbe799ace252fc53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e1ffc49663b0a4409f93b27968e070091c2e9e88163e1e0c07957c64ac9153a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e748a0998c39f1e1a8ef1c1849ed3f171e683683aad7fda6ea18e0f74f926aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eca2322de51892da6fc97d7f336fd94aa5c1eae857c268946cef1a3d13bc535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcc491ca50e36fd057a874e795b1d4f9d0f63c27b9fc586e90b63e0a1e865990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5803318d4be20bd3c7db4f1328a07344802dc279cf49c776b6903990d3e65da5"
  end

  depends_on "go" => :build
  depends_on "helm@3"

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
    ENV.prepend_path "PATH", Formula["helm@3"].opt_bin

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