class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "b6a4b8dddf0ee27f63c0476ead63f0af3afbabd78fcad7339ada0d5c8f663fb9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c109b5c0cc31a2a058ef351247583cc0c339e8ea971881df757a566c748e2fd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "912a4c522c65d4005d6dd525518ddb0e6a524c2a9bf32fa98fe9bba2a20bb19e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef5e9d24d606a8c912baca16a3b5469415a5af133ab622f9afd6ca3e14575dcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c24c30607a063675bcc5243dc2858b077da0704b65186f43799b2eff7cb6b71"
    sha256 cellar: :any_skip_relocation, ventura:       "97f4024a91c3e7135e2f6b4b9991df8bc8ed9fe772064ffcf53377e3dc1b9410"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53ff5d738afecaa8bafe2985d6874dfbdf2a94e3f1c459c6f6e7ea293cd3a98d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ddde5c752f7734aa52d79e35ae9b022f7b5ebf6b396575efb22c6b6aa2eb30"
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