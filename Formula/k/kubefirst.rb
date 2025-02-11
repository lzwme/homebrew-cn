class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.konstruct.iodocs"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.8.2.tar.gz"
  sha256 "570bf5dbefffc9addba131b6e555b2037c80732b38abc1f964e157e3b7adfdf9"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbfc72382dab5fc543129c542cecafd7edb253b345697860274da6d2742d0060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb6e3de7d057035566c82b7fd56d256ced09140563ed9bff48b4714d4fc4febd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "981170178dee1cd84049aec4188d869a7a7a51fe67059d5cab97201b01b7e47a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26eb41ee78d01c2e515f358460526514ac1e33e44206d11631044c16d305c50"
    sha256 cellar: :any_skip_relocation, ventura:       "2228e86017993038593bf895f9cc1f7a7a2a8909afc08337dd09b91aad3d8529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "790436567dc4c2c3b77c1f8aa938f7259f961f48ebde0be275280d59407e5f5e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkonstructiokubefirst-apiconfigs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kubefirst", "completion")
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