class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkubefirstkubefirstarchiverefstagsv2.4.7.tar.gz"
  sha256 "f1a263fb4bbe5fc2da063e93cb65daa100763797f6eba2e009fb001a3768b4b7"
  license "MIT"
  head "https:github.comkubefirstkubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a88c628802fcb09f1d8b6c191bb00daa87acaa81695fc0e13dff1632ef00880"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0615025cb3585eba8aa23e1ebf87c99e639b65d91f51b8847edfd3b3a7facf18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8d86b624a7ce7bad43b7d918b127f5b7dee78f13f1bb9e93e80c2d9ea1c3f60"
    sha256 cellar: :any_skip_relocation, sonoma:         "b456df5885ed7129636e113f99f10cb764b4ad8874d3e8667e71c0a82c03b2a8"
    sha256 cellar: :any_skip_relocation, ventura:        "21e433026109175b5361dec538ec5b9351d1902844ad4a31f925a05f71a876ee"
    sha256 cellar: :any_skip_relocation, monterey:       "7d19fa873593804f676255a488902b865b520dbc6d182b2900eee5cae7435d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46045d62e88d8cc834ad714559603c7f78d64375ad188403b23a48a105287550"
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