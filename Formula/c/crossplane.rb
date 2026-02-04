class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://ghfast.top/https://github.com/crossplane/crossplane/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "4c3c4f337e5a3835df862bfa24454a79b4ba2e7f242b7ebec485613db49cf716"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b7453bc87efe4115b64e3eda75ad88090d9afacf0b4c7015ab7365b8bf0d4c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53dffd29ad1289726733019de44dc891e62297ed7adf4ed8a9a8a1f8a87bb23e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6797d2a8a96bb4c4c8e743a883c72028468021fc4bcb43172dda8ad896f839e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "441cea3d27c44a5375b454c336336b69043af1e739d5aa05df589b6586d32a8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cb7b3074a626db75a3ce47d39718f08dadda3f218bc27ea3a8fa7cebabcedcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da15ac36bc0a65537d730d1612cdefb1e3fd2c1083403a4a4c442250c9630df"
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