class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.21.tar.gz"
  sha256 "57d9dd1aca40021e42025ac3a286fb36b5b8a41ca5f47247d6af08615e660c0c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8bab3567570a3934429e2988bf8d8869a1097c06ac9ec3e52def0ac46c2c940"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ac22d3a8e7bf98a14678aaf7a304a01e67367631f15b6f88754a2f269b4a1e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4d68db6af71bd94093abc759ae516f0412372198decd7ef2a923204a6c35c19"
    sha256 cellar: :any_skip_relocation, sonoma:        "afb83531333e11f2d8c7808d81f6d26f9c989d5c46583e2463443792e2a3432f"
    sha256 cellar: :any_skip_relocation, ventura:       "6e31049d9d6902c302c27cfb4cf502ccf7864e0f371b36eef89acaf7e299aaf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4871e8f035b4f7cdafea69f77ee97caa421edad7a77c4a0b6a9e904efd8ecca9"
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