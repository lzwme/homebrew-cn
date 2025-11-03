class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.15.10.tar.gz"
  sha256 "b34423a2cd3dc6a5d39ea70f12083789fdc658e3159d7c75bc90d77c549e5ce2"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d15f78305033a248f5ce615fe627a2311f53f04cbaaf7962c1d5c95c568d4896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40b426bab8d05e1c0e38d50c2f7da17c188bbf1ec0d3ea67890f3ac6eb6e4ff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b28a7ffd5b6d00ac3ad0dacfffc76e116cbab9cb87a8485c13405ca4d3a91bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f88ee1f55897c6de65fa59ca77ecec99f10cb7ccb4e7a19f2e82e557137cd2b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51926208e114772d88d8101ceddb4d5acfa034098180a35b4574cf9f689e3381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b99edbea09fb0315438cf38f7148f600bac5a1142749577db5d45e63ed7f8b7e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    ENV["BINSTALL_DISABLE_TELEMETRY"] = "true"

    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end