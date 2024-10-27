class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.9.tar.gz"
  sha256 "062779c084796f7792f717d640ec2f09407bf5b6560a9e668c73934609052468"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b37b95f189b3359b7c688e9a5544137e25369b48d1398a871e5e80b36c8ccdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "452956aa8493574c4b12f11bf719ab38139a6edc605315356672f25c209f6706"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1fdbb7e1437abdb809d53ff3adb55ef953c19e32256c9243c29bb63c5f02dc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f7648540c61b92f95628fb1b7724b38567750895dbf15dd499a99d43fd12a13"
    sha256 cellar: :any_skip_relocation, ventura:       "6a1e68eb17abf629ed8af4cc957e75f4d4da83d7e5369f87dc2e1b8d305144aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4ee9f7b071ac3e83a76933183e92a44b0545456ea5910dfd259c98732744110"
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