class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.konstruct.iodocs"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.7.3.tar.gz"
  sha256 "5fbbfa3b47a0a0d1630436c55a0c4aa971b7a1c36795b1fc9fa8a7f8b2a80bae"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50cbc1682572a122dad61bf1fe7963592a9f9f9819dcdfc489c21bdfbedfd708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e683fb35d38b6ee53b1ba4075072c0087f2a041bc95dcf99caeed3765158a315"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13c7eca6f4584bde265e8575c9e6fb47e00d89387f131f4be5f1481810e42448"
    sha256 cellar: :any_skip_relocation, sonoma:        "eadfa1fe401ae8805f8efb3e5b7b7a2c2137e51725615d3a9c92767ce06fd7ef"
    sha256 cellar: :any_skip_relocation, ventura:       "11e56602e95cbed9eaaf5d9f7c1fe13d3ef728f657ab1ed9ed71032ce3057d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "066916634bce245be6e6a1e2677f45dbd2a5eba8da0f408c9ca3712fdace4629"
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