class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https:github.comciliumhubble"
  url "https:github.comciliumhubblearchiverefstagsv1.17.0.tar.gz"
  sha256 "d20b4d6b5165c0150b4622a8bad0221d12049a44effd6b44626655731c2d6738"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae3530d5577dea63d48e064005a291a0fcc62477ce6a193d2f0a0171a217a6f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3288ec81ab4b991dbce9d1f19280c99d638917a56308284f520cd51b57ea64e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76f87085725af8988bbc1fcf31bee8c15be2300619f2e24db450d97375548d71"
    sha256 cellar: :any_skip_relocation, sonoma:        "417894eed1ef3f22bc1db11a8276866875bdd363dd8b4c451a1b7b37304745f2"
    sha256 cellar: :any_skip_relocation, ventura:       "970e7a4307b314471743f276fcebde912a790cb5d4b0789fc270480a601513ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79be5e941cd32a3d6b522478c3b84d338208ba06b7173ea8bc538302cf4d29cb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumhubblepkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"hubble", "completion")
  end

  test do
    assert_match(tls-allow-insecure:, shell_output("#{bin}hubble config get"))
  end
end