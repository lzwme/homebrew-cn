class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.7.tar.gz"
  sha256 "a0a6f30203488045d47af9d6ae86fa7ef5fd793f7c5407804f24fe78c4e787c0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49c110bf433b14a26c12402ad409291e75a1575d6f56b90a6ab349249a6257d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36618eeec7e4e83eb1b3c4e0deaa85d6e9cdee27c378f613d275cfd0c6c7af9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d49ef7d01ea2a0c1e7d03b03219f6fbdc83dc454bc5d8230269890c27f303d0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea292be8134a48d199cee023207b6a8e8aa037705485c660b9653ffbb7e09469"
    sha256 cellar: :any_skip_relocation, ventura:       "0386419162f4d848ca7bfe206fbe009ea240970115dc144a9a7bda10eec23ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f584eaf0793d5d23901ef7518cfcef9f12c973c8549b611034ab5f3c1442f4"
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