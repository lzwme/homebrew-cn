class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.konstruct.iodocs"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.7.7.tar.gz"
  sha256 "c574012f9d2050d09b060618ec45077c503b5646a7dc81581980c0bba89e7887"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "436b5fbc7a5d4c66155c7d04f909d1362f3293cc3a485e365bebff8d4c4e6dfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80f9da034216aa87280849dd950219726f3037255d8737d8af5c2bcafcbb9fa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62f4a9cffc03ebf109e5df9bae96b1876afd56be2f4313950163ef1a38194663"
    sha256 cellar: :any_skip_relocation, sonoma:        "2407f410d52113a8684589a11581b2be872572e8cd1802a88a0ccf3c65d10a3f"
    sha256 cellar: :any_skip_relocation, ventura:       "c698fe896b7c4bd22a329996d294b8707f7aa1f91f508b51f9a9a83faedef72d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9a641469b0ed30d8e5dda37daabb6b231b54be77173904824521ea6e09223b6"
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