class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.13.0.tar.gz"
  sha256 "23ad965be917d80d590f5e3dad1cb8a2b8860eec7f3c2d30f285644d1b32ee33"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81cf0d6d05c5bb00bc3546b6a134d22cafc7f35caaadbaec117fec7ae0030762"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "649f258038cd6987329df0e1065707eb61cea1cfcfda9ba6b409da95589f0d00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "437ce4ddc1b6e17a9f4c0e9d767922a8a01594d570c243c8d8d49e18998c8a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f022b66fe157459903bbfa560624457c7e06cee7e59d23feda4367952faebf0d"
    sha256 cellar: :any_skip_relocation, ventura:       "1bad25554956cf725b62af294aeede41d06045542aee6330bc40fc1b3896594b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3960a32f0ff429b715bef3d4f74e143768f9e1c7874ab4f864b405c31d756d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55d3576bf8d28d0b49f5452a943c3d04a3f70487f8b891e2dd35de3e9b0272ef"
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