class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.16.tar.gz"
  sha256 "329f140328208f0fdcf11bbb21f7798ea8cbe98186b78c33ebc4f32fc5f974e8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc874cd11f8b6f21fe74b325b34ea6eff6c6f6bbe930fdfffabe27069a65255e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1ced42e480e1a4b2413fc535ec84e38358ed88292c46980dc9a879eb61a07df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71387df1cf0e36107534fdbd77757e120947b1913f265f04649033122597b7b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb0855885ce3a12990144b37c0adb2b35a169ef59be2611c2786486bd3bad3d6"
    sha256 cellar: :any_skip_relocation, ventura:       "8f434ea1f60f51f0da1fcd8d57bf7940449562afc7212b68e7066cb58c8b2556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d42679552269724270d80f5d85a2ead175955e7771cf058bd7a23cb5bff7ebc8"
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