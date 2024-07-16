class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkubefirstkubefirstarchiverefstagsv2.4.12.tar.gz"
  sha256 "435e7425005106700e2023bd0c784ec1a76c4e8a7c404937dc0c66fdf9ede95f"
  license "MIT"
  head "https:github.comkubefirstkubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff2d6890185bd97cc8fc507542f166676539b6b7c79d11ed80e45a8e5ca528b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "926629823b922cc665aaf0165029e4e43a186f11e7b0e5d42a24ef7600526b6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ac001f80499dc9a76e1a0d5c4b3536ea32c440b7860e336cd684b8960db316c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a58ee3a576dd2193a24f10191f9879f5c4aca1eb18bf1a3f0f845c4eb91ed33f"
    sha256 cellar: :any_skip_relocation, ventura:        "17aa7b4e3d0d0b38d4ef7b1383b4bcba19f3d7cd37967e3cc22894b32db3e5c7"
    sha256 cellar: :any_skip_relocation, monterey:       "0ddbab80d44647640df43b8adfb25fca487d67c51f952c3b45a46ef6c356a789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52431950b0e0b94c39f2ebb32c7924ee37d1749e44cec6bd6a1889789f216f63"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkubefirstruntimeconfigs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin"kubefirst", "info"
    assert_match "k1-paths:", (testpath".kubefirst").read
    assert_predicate testpath".k1logs", :exist?

    output = shell_output("#{bin}kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end