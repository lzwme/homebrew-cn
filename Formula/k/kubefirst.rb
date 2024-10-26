class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.konstruct.iodocs"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.7.0.tar.gz"
  sha256 "909ef6dda165f063d12ade65cf544ef16d7679cfa97a8380dabbb3067dfebe3f"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfdc927f1b4450fa4ec0c6801a7dfbb542baf5db9d6d21978465818a64c87ff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ae527b8c85ac07f7c6e6bb25f4502d07f1d5909c5480b5b010f184f0ccf4919"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0b357c1305c220c54ceed2f159bcb53dbfa4580f436f29be2e9809fd9d76480"
    sha256 cellar: :any_skip_relocation, sonoma:        "75f335272c76beb2f14320c599710a15fdea4a455b05a84a1ea19d2a56b9a323"
    sha256 cellar: :any_skip_relocation, ventura:       "50c6df69e477fd45d4b8c252d93c11b0889dc22c5113e30d3aa579beeec7e655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2892e0519480d8bcf9af6ae1f075688db38e630ca5aa82f0f30c92dc4f72c9dc"
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