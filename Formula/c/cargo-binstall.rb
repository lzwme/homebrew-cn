class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.11.tar.gz"
  sha256 "71e2a0570ec97cc286397a0d7a86811ff8e0cc57bfaef5651ff5a5c951e6881b"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebc10d3c5dae3181a7e654e8c1905418a91ac28e9bca65af001860e3fae5c3e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7998f669c0ffb329f70d345a5ae107ddea44de71072bea4d88245c8a182891f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbfeb431dc10973f3d59ab1d4e71f2d38c2b93e1ed373f886f7586694a3c70a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d03d6307136c6f8b10c709a0e67a199789d0a4163761041094659d5d8297e6d2"
    sha256 cellar: :any_skip_relocation, ventura:       "5745e124509a6b3840564d56f1b4f36eba17f87f8cc36c4a937166d9be6e40b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664387a85386b729f15e9b91e2db8d8095b2ce7848f875816345cfdaad2806b8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  test do
    output = shell_output("#{bin}cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}cargo-binstall -V").chomp
  end
end