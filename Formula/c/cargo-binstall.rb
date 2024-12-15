class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.17.tar.gz"
  sha256 "932a7c566d8bee843885bdfa1a53db84f3b72271ea70f02003a4a2ea6ce2f466"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44e05c88dab9428c8b691a1a2158dbd863679e2620ad1c72c6202b32234c57e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "534fb21e8bea2473fe0fd74d20273f5478cbd89a16df76c1b7c10f109ac4936d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3272bc94ad585c33f19a33d37bf09927af55c66faa810e391e8a80f463b61120"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bce7999b2eea69ef0d90cff5b7176fd033995a15484a626aba3d33ceff1659c"
    sha256 cellar: :any_skip_relocation, ventura:       "65beddbfe413c635ee9761d6da04491b1f28f730a8ae50c379aa34be403571b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76a681d8c3f22a76ca85456292fe2e3e33315612ee52bc285b310c929be4ff68"
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