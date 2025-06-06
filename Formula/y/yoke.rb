class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.13.4",
      revision: "cac5ef08b7ee7728b35a581e809e68583b6079ac"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dfe1892914e2eb09b72757cf054c909ca8743d045c4e226613e15830bf6ea27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2961796847155900d0c9eb6536639d2f3e4c51fce7c1f8c74f2951d4b66679e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ed3a774cadddad6ce2cbebe26afe76addebebf7f11b64e39e53485d3ea92d33"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0f85006a1f69651ca0cf804c6cb52f44d097553b177dcd49b6b2e0495daf07d"
    sha256 cellar: :any_skip_relocation, ventura:       "d238a1a28793921fdfda73a2b91cc4168c53dae4c794b7b9bfcf065e69bbf34c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b4b727861dae66c1bcc31f8b9b8e670e0f1d886e64bc6863e595cc75bf5ba2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e44c52522b65e59d6dd86a7d21910ecd61ec9eae966bf2792d241e2c7f1669c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdyoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}yoke inspect 2>&1", 1)
  end
end