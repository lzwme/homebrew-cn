class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/cli"
  url "https://ghfast.top/https://github.com/crossplane/cli/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "dcafe7e43a2aa718b4c766754800cedf0ce5b7d8df9f6b013f26d24414460e71"
  license "Apache-2.0"
  head "https://github.com/crossplane/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "615972f2fd8fce3ea25835cccad1ed481f621492a34cf9851bf65f9e580c2aac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d201f391bc8a058fcd5d88f3fc90b2ce0e1c99aa464152c5da00c0d659e15aec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5161cb5f396bbf129fe0e546effe21bbda510670a78f970c8f3f66a26b412116"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ed2fd00cdf06bc1019e51746c8ae5e89936049d0678a5200f1dfc8afe5ead8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a13066c0571691fb14ea4690791b0e110b0d90728ca9a3bb7ba1989cb78a1fd"
    sha256 cellar: :any,                 x86_64_linux:  "01fe2d0ac90d9e0227741d259b24e2628ca2419274303851ea8796c4e184f708"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/crossplane/crossplane-runtime/v#{version.major}/pkg/version.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crossplane"
  end

  test do
    assert_match "Client Version: v#{version}", shell_output("#{bin}/crossplane version --client")

    (testpath/"composition.yaml").write <<~YAML
      apiVersion: apiextensions.crossplane.io/v1
      kind: Composition
      metadata:
        name: example
      spec:
        compositeTypeRef:
          apiVersion: example.org/v1alpha1
          kind: XExample
        mode: Pipeline
        pipeline:
          - step: example
            functionRef:
              name: example-function
    YAML

    output = shell_output("#{bin}/crossplane composition convert composition-environment " \
                          "composition.yaml -o converted.yaml 2>&1")
    assert_match "No changes needed", output
  end
end