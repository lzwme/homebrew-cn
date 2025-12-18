class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://ghfast.top/https://github.com/fastlane/fastlane/archive/refs/tags/2.229.1.tar.gz"
  sha256 "3e9c945e804cf99f20e0d29fa91c2fbd7cf303c171cf7b36c7b125b49a776e45"
  license "MIT"
  revision 1
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "24c5b266f7e958bb92a80f7fc051c077286ae4fca39df9d7614e3599df803af6"
    sha256 cellar: :any,                 arm64_sequoia: "6d2fe272ffea1f5a1f32315dc35878bf82e0ad8fbe363a65b385f2a8b16404cb"
    sha256 cellar: :any,                 arm64_sonoma:  "e0fa319ec1b0196a7d38098d34776acf579555f262e88c48a21e922a9fa95f6e"
    sha256 cellar: :any,                 sonoma:        "e684737d1c1237ceb833a4e41d08b71c7ac97a9ff3721fdc70bd2514198b8288"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0ebe1508dde6c09f9ec02f4eea681884dc9c5feb68f5b6f75e6e8ab780b1a12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42815d472814a9df0ab2faeac4086533d73d5eb4a2845823a2d837b39debe57b"
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