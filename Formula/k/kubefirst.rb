class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.konstruct.iodocs"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.7.6.tar.gz"
  sha256 "81d58574f8bdf11466cf71bf923745906112e0e7e7b0510491bd81a5a0012ebe"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d73d7687e152221886fd11f992bf05c05e56c6b5e908f8935829dc5c99deefbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d2e580bf06424c54567c112c905987ab4ec9da9d56d8a9275c2f40db01a693d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09f00d7cbbd05fa703f44e90058e69eed937a103cc15839099bd1953c2605998"
    sha256 cellar: :any_skip_relocation, sonoma:        "4598407b312741171ef8a750695c223348b0aa050c7f53e36af0accd59d65587"
    sha256 cellar: :any_skip_relocation, ventura:       "25150cc31a3d8e2fc2d05b868ce864afed5536f755c0d5083e1bb0b855f7db01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18bca93a37ad4b34fc2538015bcfd53ae55e8264568e22e3bac761c245496ddb"
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