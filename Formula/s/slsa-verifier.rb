class SlsaVerifier < Formula
  desc "Verify provenance from SLSA compliant builders"
  homepage "https:github.comslsa-frameworkslsa-verifier"
  url "https:github.comslsa-frameworkslsa-verifierarchiverefstagsv2.7.1.tar.gz"
  sha256 "19af322eb0ae0cb738f8e2395b3dcff756537277d62688fc9d2b4fc5ad6b16e4"
  license "Apache-2.0"
  head "https:github.comslsa-frameworkslsa-verifier.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcf61ec25f8d27700570040901164ae290b194cd0da63fa2e6468d45964d2774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcf61ec25f8d27700570040901164ae290b194cd0da63fa2e6468d45964d2774"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcf61ec25f8d27700570040901164ae290b194cd0da63fa2e6468d45964d2774"
    sha256 cellar: :any_skip_relocation, sonoma:        "61d1c99d4454cf0ef9ea24751e1eae302d84f59f4c094f326b0d2a6e2e225c2e"
    sha256 cellar: :any_skip_relocation, ventura:       "8f635db74b4536deb743eda7c09aa6cf9982efdae9cc4faa48d8ddd5f6c59d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83f420ac94e1c93f8ab68a0f831011f204bbe1b12774304dc01cca516bb1a1c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.iorelease-utilsversion.gitVersion=#{version}
      -X sigs.k8s.iorelease-utilsversion.gitCommit=brew
      -X sigs.k8s.iorelease-utilsversion.gitTreeState=clean
      -X sigs.k8s.iorelease-utilsversion.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".clislsa-verifier"

    generate_completions_from_executable(bin"slsa-verifier", "completion")
  end

  test do
    uri = "github.comalpinelinuxdocker-alpine"
    output = shell_output("#{bin}slsa-verifier verify-image docker:alpine --source-uri=#{uri} 2>&1", 1)
    expected_output = "FAILED: SLSA verification failed: the image is mutable: 'docker:alpine'"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}slsa-verifier version 2>&1")
  end
end