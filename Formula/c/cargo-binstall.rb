class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.19.tar.gz"
  sha256 "6b35d589c03bbd8b98a09f0c752e1ae84ef788ff8eb5b5704483c8cae38a2975"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01cab0c4790a2c76a6b2537669913afe54806d55f27447ba072885f84d06f247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1aae2f2024455f93b038722299d02d8a85069de2942fc88521138f00e00e061"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7553fd80f456ce7d50bfb47c45edd3d6f0d3991066859496e32a3ae0d5571ca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ef862255f146cdd1b274ce8be4e62b034787a483071873504f6a2c532d33644"
    sha256 cellar: :any_skip_relocation, ventura:       "0fb812cc041eca0d68bcd3ee7e7d90ccc6ec028d469f03758c681c4483242fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deff4d7932aee2f7232cff623f6dcab4e0b54c5beb0a646567215f6f3ca45936"
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