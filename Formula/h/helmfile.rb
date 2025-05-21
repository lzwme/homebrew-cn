class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https:github.comhelmfilehelmfile"
  url "https:github.comhelmfilehelmfilearchiverefstagsv1.1.0.tar.gz"
  sha256 "b9e4af8ec869e1438919638a5e364f2eb5ba854ff83846c992fa24a7e498339b"
  license "MIT"
  version_scheme 1
  head "https:github.comhelmfilehelmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a484dc7c186c6381d97d7b3d345e5c0a0bb593362554b615e035ccac8cf180b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f77d297a28d529108cc9d6f01ba6c69b50990d7f1d2660777cc00798f8e8e38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8e59b3c13307588ccbe9a24e45f239d39dc35a561f3ca0ef24dd53bfe237b3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "864ae891fd48b7d70c78ca6479778aae0aa3cfcdaa9c559a13a94c588b2f7cf6"
    sha256 cellar: :any_skip_relocation, ventura:       "e330ef9a24058a04e9deab8bc388ff90aad2e0cb87e8bff48473d93a7f810d49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "033bd2a15ebbb34c68c47ddf58185cc16b735f0c98914b63610d40a265af47de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a79ad7e21cc0cd6e07a23f77d84e8da5a00a4ce5870bb6e2f3a32c0a74fe52b8"
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