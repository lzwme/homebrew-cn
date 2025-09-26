class Bom < Formula
  desc "Utility to generate SPDX-compliant Bill of Materials manifests"
  homepage "https://kubernetes-sigs.github.io/bom/"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/bom/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ebef4f8c86cf614acb27be4696c1f5d2394c68bb9312e5b26736721f035689fe"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/bom.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99b4f083ab09978bdecc2718fa387c857700dbb12f1a4c581f59c0bf01522f81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99b4f083ab09978bdecc2718fa387c857700dbb12f1a4c581f59c0bf01522f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99b4f083ab09978bdecc2718fa387c857700dbb12f1a4c581f59c0bf01522f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "1646b8a2de3c143c28009b4f4c3389e36acc916776e38dd3680e63d623556058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6674782ab5e1a6f950f16c5af892218374afaf9c4805b7134495471811863c4c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=v#{version}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/bom"

    generate_completions_from_executable(bin/"bom", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bom version")

    (testpath/"hello.txt").write("hello\n")
    sbom = testpath/"sbom.spdx"
    system bin/"bom", "generate", "--format", "tag-value", "-n", "http://example.com/test",
                      "-f", testpath/"hello.txt", "-o", sbom

    assert_match "SPDXVersion: SPDX-2.3", sbom.read

    outline = shell_output("#{bin}/bom document outline #{sbom}")
    assert_match "📦 DESCRIBES 0 Packages", outline
    assert_match "📄 DESCRIBES 1 Files", outline
  end
end