class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.konstruct.iodocs"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.7.8.tar.gz"
  sha256 "6e071b3b6f40bfac8cc110bc2736ed25f85b44933a345fd1b6db0859ccd2b480"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ec9dec30968e9aa8f2c2641dbd5b622171da3de194b192965081d009cf1ab7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "022b108c9e5e3eb39c87e3a3a80fe08dfdb1791dcbb04c6e360176f51681fdde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cb3f9e5b4adf5d4becffeb7d37ebcfb7393e4e3bdcf8c5a0942908c1e00940b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc84ffe6835556902ddba5d1dfceb71d45b143dfcbb288d71d33af3bbf494d81"
    sha256 cellar: :any_skip_relocation, ventura:       "61faf2d20a3f28a6aa23d041ccc92690f6eb03f7ef948acab394fd72edceda99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ed596fe714d4f4ac24e242e46faac7300720e039cf1f251d983b10cf7f5c1dc"
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