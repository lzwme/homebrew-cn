class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.5.11.tar.gz"
  sha256 "8ece781cfc3c218d9ea0b28e06c83135d69954c39886781b518ece9476bd6072"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "131d55fdfa1335e869bceec534f12082691582770dd41489120851f2da06927c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44b2d28f6711a30d034b1cadc7cb861a13f4b7d68fe8592f5aa4c8fae0fcd6c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e175283e81f737098f0d9b4a79e53a2c65315ce0b5f03aaf115fe00cf40ae925"
    sha256 cellar: :any_skip_relocation, sonoma:         "9537fa1c474aef7f0da5f5c164e64ebe9ea7c8a6c370716a3a3d567c4dad507a"
    sha256 cellar: :any_skip_relocation, ventura:        "f287a8c5e2695640e083025c7084b2c2272f84a6343ce436480ab293c308a360"
    sha256 cellar: :any_skip_relocation, monterey:       "bbb1afb0443b6daa3133d2b2761a3fc8e0b130b1d9bdd8157cfb0f4b4d4d4452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "552f57f7c0cc5bcd23bbcdfd0dd25ca84156ddf1288a38242d2a9917362d32be"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkonstructiokubefirst-apiconfigs.K1Version=v#{version}"
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