class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://ghfast.top/https://github.com/kyma-project/cli/archive/refs/tags/3.1.0.tar.gz"
  sha256 "883d938c55e89e92dad8e17ed46c38e47b2c46fdc8ddd1995160970798e83ee3"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bc104e06d044ef7850919836bbfe75abc57423cd6f33282f0390607ee6564f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d16775880e4e73cc164b669ee89dec1fb95068a322be3b70e4414ec215a78f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c44cef51548a22c4565e34671323ba1a53573f4f4e4da4ba8865eee1441af7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2541cfd85e7290c4dd67dbf812abdcf2a31209835cf8f859334ba4c9a81f27f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7116d4a8252c30f1eae9a449a7e69a2701b75ca6f3420cc10387de3f24bd387"
    sha256 cellar: :any_skip_relocation, ventura:       "049c8a10b9e9904165a2172b71eb7affdb907bd4f3f42c2c3f97d92186ef10e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0c9c9af85ceac2c61249afa3032d0db57e436c6be9a118d1d65804612f836bd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli.v#{version.major}/internal/cmd/version.version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags:)

    generate_completions_from_executable(bin/"kyma", "completion")
  end

  test do
    assert_match "Kyma-CLI Version: #{version}", shell_output("#{bin}/kyma version")

    output = shell_output("#{bin}/kyma alpha kubeconfig generate --token test-token --skip-extensions 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end