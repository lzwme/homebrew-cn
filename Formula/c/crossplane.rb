class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://ghfast.top/https://github.com/crossplane/crossplane/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "569fc1bc4dd34b022fe1ebb9085e67ea8ce7d77bfbc4aa0a6f417baaceab3cb6"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48f005076c942214cc6cec4447e20bcc81e9089756e8f90c9100a3c611c12381"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7664fe926445ebf3ce32d88465ae1339ecc69dbb9ac8c6174037773bc360c658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1caa078cd06bb00bcca6faac8bb810366add95a709cb6b8e36dc71fcdcb8349e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2fe45aff5783cba69bafcfaa29c55800f9c10654be868e6c1cf36b43c44f9e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d757ef1543bb279834458d7ee54e784f07649a815a52e31911f3747421769378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28143077a5431a404ef3213b5f03206e748365d2fe1bea2f39e71c3e0dbc6643"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/crossplane/crossplane/v#{version.major}/internal/version.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crank"
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

    output = shell_output("#{bin}/crossplane beta convert composition-environment " \
                          "composition.yaml -o converted.yaml 2>&1")
    assert_match "No changes needed", output
  end
end