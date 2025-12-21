class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "cf9b4e96830c8562a6b0436e102d2117d8b2cbd9b7dbe308e6a6d032ed7e7a1d"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b774993cafc17cea025b96fc0fea64ee3c331ef5bc1a197bfb903bbb595ccc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f5dee5de8174295d10399a6de9a4ba4dbd9f78bc9838535900ca7456921f928"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bfdbc41e1aa53819967c0107ba3418aaea984be04d9faaeae60863f6ebfe24b"
    sha256 cellar: :any_skip_relocation, sonoma:        "174ccb2264b9eefbb5a8c20dbe2b8b81baac5635c3416cc8f5b3023e1ac90696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87684a2fad816c33b077476fdd1ec284c682c2ab61b30f17598533c29155559a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88a875222896dfa0ec9b18823761b6fcf21cb78ed8cdd8532c9fd18946cf639d"
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
    system "helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end