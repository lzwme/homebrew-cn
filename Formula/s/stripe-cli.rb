class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:stripe.comdocsstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.23.6.tar.gz"
  sha256 "5868d029e614b585b84034056458d6ca90470d77a6ded047d3039d893ae8d1fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0514e8db3b85f9a0d4d7cf119913e86038e44946b62537ddb710a546f8402259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43180dd9accca6bf8dd319cd13a03eea28bf0bac913f9e2585626e331de4d5e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "908d1719e7202a73430c156d5855d3acccc08653308abb375bb516d2bb12be6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b080d5c126052d5b49363f8c2314efeaab64f48781dd6fb363833267c0a23aeb"
    sha256 cellar: :any_skip_relocation, ventura:       "27105465472cba7e37c93492ed7b0cdf69886db78f65dd6f49e8f6f78656a04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3c56d3614dbb96103a972a71f714a952e363a8fcf801163bb28134d4e2e2490"
  end

  depends_on "go" => :build

  # fish completion support patch, upstream pr ref, https:github.comstripestripe-clipull1282
  patch do
    url "https:github.comstripestripe-clicommitef36be45f56821a33ac175bb4f483f08cca3f458.patch?full_index=1"
    sha256 "e64d6ab6ed1b93749b8d65a429b0132063fb86520960b7d0c87fa6f7f9221252"
  end

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.comstripestripe-clipkgversion.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin"stripe"), "cmdstripemain.go"

    generate_completions_from_executable(bin"stripe", "completion", "--write-to-stdout", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}stripe && complete -p stripe'")
  end
end