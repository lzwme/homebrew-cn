class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkubefirstkubefirstarchiverefstagsv2.4.16.tar.gz"
  sha256 "7c4538a0addfe6729335c9f4ea8b9515fecba759d768ec5134505826aa86c6b5"
  license "MIT"
  head "https:github.comkubefirstkubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11cf9266fefafc9da3e0f521a371905e0dd315f68dbcbf2c8c88ec6cba65f72c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc367a1025275f7cb5f7f53ea68a34cfe1d4edea6aef070b16c1fbe9af31b5ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "245dea9409d1443605a7319c886fa1dae078ba1655335167772b0039cfae327f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a7370af7516d4a2298a27b6fd9a4269b8b6c6a25dcb46dc02e5c47dd9c0f817"
    sha256 cellar: :any_skip_relocation, ventura:        "223a32309b41386aae35787e7ad4257ce250e9fd9706c39742f924c56812b674"
    sha256 cellar: :any_skip_relocation, monterey:       "2633a4fce0574c0294ae0529c9fe8d81118e16798f250c45cf3ecc801a9b769f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2363e7805c66c65767999e368e0c8cb5faf51679d7243f53ca8c8306b1745905"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkubefirstkubefirst-apiconfigs.K1Version=v#{version}"
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