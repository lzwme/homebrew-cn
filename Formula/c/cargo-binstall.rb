class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.13.tar.gz"
  sha256 "96ebeb4fc8d2072eec53ca7b2efa1263c76bb73b3d136ea5d66767c1ef517f2b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41a758ba5501279326bb48d84ecebe8bc871ddb3e3de2c41c460d80deec3c3c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f00466f6d02158f340b9685eefb93d591809edbcb60b256f5134092cee976a88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3bffdb42990eb9e088ed25c9146c42440d7e2f6bb74a250ee75a0bffe66b427"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f42e4d11e7b4821640dd37f6ee99b0609b941bceb97c25d6e469cc6d85b142b"
    sha256 cellar: :any_skip_relocation, ventura:       "0194d366fa912560e5d7ed2df09c3142a726a6e17059341aaebdd1ce5d03f1c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4d6410884076df5792ec467107beb95604ecde20b2a144cda6abda9e08aee8e"
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