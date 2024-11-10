class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.12.tar.gz"
  sha256 "fde425f6093471b9f4648f54c8effc1b0ad23e39014646fdcfc0e2c69727fa69"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eafff5330327964718b03a15e3a6c93bfcee8c78d5a8d761982ceb0f6772b538"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8e2add6fec0b20f8343dd5b2e0cbf217c416e1d8e31412d3a24cfb8106ff014"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8233885f5dba36bc662b3fa113c46ffa232126c04264b0431257871fa097e17"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6b35c0129ed19445ace88dfe301a2f2a8a17c191ce0c8e977c1cf5755cb069f"
    sha256 cellar: :any_skip_relocation, ventura:       "f802e23bf7874d03dca874903aff46e16ee16c89b01efb5cffe5d9cfaec2dc5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bbdc84d2ecb557d76374f4ae9a527727f5f5736e464f7a4fc1cf41b1de9cef4"
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