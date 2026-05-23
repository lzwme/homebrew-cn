class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/cli"
  url "https://ghfast.top/https://github.com/crossplane/cli/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "c4bd32825dd32c2ff5028c4c450168b9894bbefe54109e6f5056ac648a080f2c"
  license "Apache-2.0"
  head "https://github.com/crossplane/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba62b5174daaedbc38d97e28ecdf518971a0f3f8831809e741389b0d0ee79d92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1736b4232af35bfc8dd98419b98eecd2ef42cb2ac3623249f4f35a536253c90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36cc10dd37628bd8f5138d36438a0b919c74c4403990a87b0e7dea66f48c9195"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c4688619cc30106d0a1be3cb76d0352ff64947f49516cd61dbfcd9282d43dbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7adc620c1ffd84fd04a88f36e9c6004830d55e8554481ba1f6ccce5c4e17a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa5263c3c233cd83e7679c48983e185e5f434a3b745e05a1e8f4af4959729d80"
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