class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://ghproxy.com/https://github.com/fastlane/fastlane/archive/2.215.1.tar.gz"
  sha256 "42457180f8768f6bbc999706eb53099f29b4958a61b5236588ef1ee1eadae24b"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6a2f4a37bc867a40fdea3626dc9d422d2289299bc85e7e8036ef2c1f3f22e032"
    sha256 cellar: :any,                 arm64_monterey: "2e555e5535745a04e2c0bdce825238b04223aef4a147864bfdd15ccd5cdd7096"
    sha256 cellar: :any,                 arm64_big_sur:  "0d6493415ff440389afa7c06d7ff838d62a48ca7eebdb4d9645b7d5cc0bd40c5"
    sha256 cellar: :any,                 ventura:        "eddf075970fe575ca64c1eff382afb25be50d84fcd504a8a3ebaaf7e56ede317"
    sha256 cellar: :any,                 monterey:       "74e36c33e134b53de025dda182f1ae6fa102186204e7f1cbf2117b19da910d5b"
    sha256 cellar: :any,                 big_sur:        "1c889feced1126f6bdf5651225a0b9102069a42d2f072f4a9bcb0b0a25bd35a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8430ccb1c44c30a51913a86afbc9c16fdb73d8311a9306f917bd5d4f298be7e6"
  end

  depends_on "ruby@3.1"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write_env_script libexec/"bin/fastlane",
      PATH:                            "#{Formula["ruby@3.1"].opt_bin}:#{libexec}/bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        libexec.to_s,
      GEM_PATH:                        libexec.to_s

    # Remove vendored pre-built binary
    terminal_notifier_dir = libexec.glob("gems/terminal-notifier-*/vendor/terminal-notifier").first
    (terminal_notifier_dir/"terminal-notifier.app").rmtree

    if OS.mac?
      ln_sf(
        (Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app").relative_path_from(terminal_notifier_dir),
        terminal_notifier_dir,
      )
    end
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end