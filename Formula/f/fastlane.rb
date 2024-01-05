class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https:fastlane.tools"
  url "https:github.comfastlanefastlanearchiverefstags2.219.0.tar.gz"
  sha256 "100458a3bc60c23fbc374748b7eab3f4666aa50fb84ffe94daa9e074d5dbf059"
  license "MIT"
  head "https:github.comfastlanefastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "397caeb13a5bead9215f885df5d6aea7b8a26bc3ec210ea6ac75dae8c0d6779f"
    sha256 cellar: :any,                 arm64_ventura:  "cb915232b6657002178e4db3cc6d6b71227fe2bcc69ac0490e7946ec733ec905"
    sha256 cellar: :any,                 arm64_monterey: "0f7ec9e5855c0a8f9018c82132802fa7858524f8cc38cf4b2bb0b0844f648279"
    sha256 cellar: :any,                 sonoma:         "0aa6a12d03a67e17da1581eccee4185df6a868b6141f9efd3c54fe36e44b6f47"
    sha256 cellar: :any,                 ventura:        "bcd08fdb7202bc4bba640010155b1a59be548e89fa72e2d420bfa5fcfcca7d6b"
    sha256 cellar: :any,                 monterey:       "755e44135e6c81a37fe7f7a35d9d6e0b577a6eacc8f733d187450a63feed5132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33f43c7d3371961a0f928275ba75c6c1ed9ac235483d03ed76c574b7772bfb53"
  end

  depends_on "ruby"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin"fastlane").write_env_script libexec"binfastlane",
      PATH:                            "#{Formula["ruby@3.1"].opt_bin}:#{libexec}bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        libexec.to_s,
      GEM_PATH:                        libexec.to_s

    # Remove vendored pre-built binary
    terminal_notifier_dir = libexec.glob("gemsterminal-notifier-*vendorterminal-notifier").first
    (terminal_notifier_dir"terminal-notifier.app").rmtree

    if OS.mac?
      ln_sf(
        (Formula["terminal-notifier"].opt_prefix"terminal-notifier.app").relative_path_from(terminal_notifier_dir),
        terminal_notifier_dir,
      )
    end
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}fastlane --version")

    actions_output = shell_output("#{bin}fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end