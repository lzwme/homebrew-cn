class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https:github.comhelmfilehelmfile"
  url "https:github.comhelmfilehelmfilearchiverefstagsv0.169.0.tar.gz"
  sha256 "e0401c4ecc81101d4bd17f171bd6e6ad6f6b50adbbc46525a83d01d1df73ae0c"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebb390acb8fc2a96c59b66dce3fffa11860b4d16f39b10d00cedadcc77dcc94f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5b08c57eb31b05c7ea64c5d94226d001ae79d96b135d73522a7a8a1cba6a35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "246e229cb705ec26730fd79d5d4a188be65d8c7d0f0e6ff1d62a14964f6cb209"
    sha256 cellar: :any_skip_relocation, sonoma:        "543324f6bea6127c49ad7765bde5b1ff21add9094f4ba3af2bfc6e26b68ccf4f"
    sha256 cellar: :any_skip_relocation, ventura:       "e71106e4146b2f4165c175bf9756b1730c2b3ea8d65ce78694cfb0401a37d425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "955fbffbce006e57aa8693a1351f1cc5ea8e24c7ac41ea670f4a9a452f4a4b5b"
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
    (testpath"helmfile.yaml").write <<~EOS
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
    EOS
    system Formula["helm"].opt_bin"helm", "create", "foo"
    output = "Adding repo stable https:charts.helm.shstable"
    assert_match output, shell_output("#{bin}helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}helmfile -v")
  end
end