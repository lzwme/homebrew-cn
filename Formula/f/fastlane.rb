class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https:fastlane.tools"
  url "https:github.comfastlanefastlanearchiverefstags2.218.0.tar.gz"
  sha256 "aed7d5d81db45ec41ff5aad978f490c64747c18ce250259a0b1e8f4d984b86f1"
  license "MIT"
  head "https:github.comfastlanefastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5b24952b36eeed280a7250515308c6b9ac0edb26956e5904c09d9dea78436563"
    sha256 cellar: :any,                 arm64_ventura:  "7fb86e16264f21b3229dbd009ebdb80961951d5fc86563efd54fd605c4873663"
    sha256 cellar: :any,                 arm64_monterey: "ac464477b285b13c74a2d9890286f1fccb37e17f5cdcc14e2c1d418ff03f9f59"
    sha256 cellar: :any,                 sonoma:         "c2e10e9c0693c4d0858bad8ad742202d43933e80688207de030e053e786fc188"
    sha256 cellar: :any,                 ventura:        "450c1ff9f9f3e920cb76cc7f7144fdf4e6a6e6324e1c636ba2635452fe22df79"
    sha256 cellar: :any,                 monterey:       "6a6c1d6bd33b3b650f58aa553d532510a861de8a1dcc16c4a5ca97309437d500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e23f16f77c108c058bf437d84818fa0b36270e2ede3dc6ede0d7bd26a4f140ad"
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