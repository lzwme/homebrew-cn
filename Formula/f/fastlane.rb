class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://ghfast.top/https://github.com/fastlane/fastlane/archive/refs/tags/2.230.0.tar.gz"
  sha256 "e496600b49a3eda2463964eedcfdb4d0c25751cf2a1fa59de9f09719d249ed06"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74d28fc218e13f03f00d728dfd8fb7b82f2c6115743207de235e899c321036db"
    sha256 cellar: :any,                 arm64_sequoia: "2218d60acb4b703c820ca4b42908dcf4121c98b76e713bb4c12abc2958f1ecde"
    sha256 cellar: :any,                 arm64_sonoma:  "a1f3980efa4aa6680e69fa8698401da77342e98efcae255312808cc25801ae9e"
    sha256 cellar: :any,                 sonoma:        "6e0626dba445258861c3cda068ba97a16f4cbbf6c18856fd02df35511c16033d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dd36c8d985f535c78035012c8bf25c398598640d7d4e99f3f528a3892b41d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b89366f8237c761258ee4296c4e0a968b01296c498ed3102512f5c5a483b86b"
  end

  depends_on "ruby"

  on_macos do
    depends_on "terminal-notifier"
  end

  def fastlane_gem_home
    "${HOME}/.local/share/fastlane/#{Formula["ruby"].version.major_minor}.0"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    # `abbrev`, `mutex_m` gem no longer with ruby 3.4+, upstream patch pr, https://github.com/fastlane/fastlane/pull/29182
    system "gem", "install", "abbrev", "--no-document"
    system "gem", "install", "mutex_m", "--no-document"

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write_env_script libexec/"bin/fastlane",
      PATH:                            "#{Formula["ruby"].opt_bin}:#{libexec}/bin:#{fastlane_gem_home}/bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        "${FASTLANE_GEM_HOME:-#{fastlane_gem_home}}",
      GEM_PATH:                        "${FASTLANE_GEM_HOME:-#{fastlane_gem_home}}:#{libexec}"

    # Remove vendored pre-built binary
    terminal_notifier_dir = libexec.glob("gems/terminal-notifier-*/vendor/terminal-notifier").first
    rm_r(terminal_notifier_dir/"terminal-notifier.app")

    if OS.mac?
      ln_sf(
        (Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app").relative_path_from(terminal_notifier_dir),
        terminal_notifier_dir,
      )
    end
  end

  def caveats
    <<~EOS
      Fastlane will install additional gems to FASTLANE_GEM_HOME, which defaults to
        #{fastlane_gem_home}
    EOS
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