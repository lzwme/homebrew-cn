class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "0f577b7d7e10e6ddcb2eaedc10df50dec57d95f06f88411119bfbd62240f488f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4711c6ed0df576d51257d7e3bba0840b8d30294df4dbe003647c5661b8b1da3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "160e7f12b5d5017bfd43e420710ccda21c448b158d2b691532633a4bec381ec2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1d377a2b196bdacce1c199b0330016d6d074deba268cb077dfe71b0aa47c8e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d7f2eb7d19fa038e5a6d676d6c22410a27881bbb1ad5de97c9166ba6fad932f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e0476d4ac63777eeb43615bb149303ca9756090f40acf6ea4c4a84d7a84d58c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0a754185fe400e1957dc9b879b996e1d4bda649b2effc048c0cff0d2d3d0c54"
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