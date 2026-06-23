class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/cli"
  url "https://ghfast.top/https://github.com/crossplane/cli/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "8121844ba24b59cea86a0b21482f1d0c29a9b9c587d1516f9471670eb67040a5"
  license "Apache-2.0"
  head "https://github.com/crossplane/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc0319a804a93fd8951ec735ce6d585e87497505205bf06ba6b4124c35cb197c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c31abf0236d0c01b0862b4309f4e65069c8040e6de3862158dc6995ffb069f09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41ba1ff63456328a11076e94fad776244f2b22a2ea15c4b7c2749fc4de6dcbe0"
    sha256 cellar: :any_skip_relocation, sonoma:        "012e17a5c07b578eca19446ae98210426fbf68522cdce7a10e3c45b3ce70f0aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cb7739bbaf74a12a63c60b70c9a66840a9fd07acf7cd9090ddc4818502bd176"
    sha256 cellar: :any,                 x86_64_linux:  "74ce6339978b0471f8946dd9b602d9da5aa17e4d7b34b63754507acfd7f3cc53"
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