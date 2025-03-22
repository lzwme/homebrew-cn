class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https:fastlane.tools"
  url "https:github.comfastlanefastlanearchiverefstags2.227.0.tar.gz"
  sha256 "4c80c983278db5b74f42c21dbb80f4c6fd7683d73f9970787111b0a510ac2a6d"
  license "MIT"
  head "https:github.comfastlanefastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9fc7bd9e9e19b2cb3ca20774fd490d24151d0dddd014f3c88861aca063d2f2a"
    sha256 cellar: :any,                 arm64_sonoma:  "f313646e4f16c3853ef225f8dab0c46b9be42e1016328979249206323d925a73"
    sha256 cellar: :any,                 arm64_ventura: "022f6f852ae145d43dd395c1030346e377bb0ea91e299b33b8211fc883a3a2d3"
    sha256 cellar: :any,                 sonoma:        "5d3b2fefdee050924289b54cb31d1e59afb9223661facf0f364acf2376deed54"
    sha256 cellar: :any,                 ventura:       "af2cd6c04cdd2672d236a5468951bf5082777b18e62a663dd88d7558934c2049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9efd8453d8020ec06acd625b391c1139e4e00adb8546e1e2bbf066cd832ce1f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af4d08fd8e0666c73ef3ee1958bf2715cbe91af3a7042974f7137987c32418b5"
  end

  depends_on "ruby"

  on_macos do
    depends_on "terminal-notifier"
  end

  def fastlane_gem_home
    "${HOME}.localsharefastlane#{Formula["ruby"].version.major_minor}.0"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    # `abbrev`, `mutex_m` gem no longer with ruby 3.4+, upstream patch pr, https:github.comfastlanefastlanepull29182
    system "gem", "install", "abbrev", "--no-document"
    system "gem", "install", "mutex_m", "--no-document"

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin"fastlane").write_env_script libexec"binfastlane",
      PATH:                            "#{Formula["ruby"].opt_bin}:#{libexec}bin:#{fastlane_gem_home}bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        "${FASTLANE_GEM_HOME:-#{fastlane_gem_home}}",
      GEM_PATH:                        "${FASTLANE_GEM_HOME:-#{fastlane_gem_home}}:#{libexec}"

    # Remove vendored pre-built binary
    terminal_notifier_dir = libexec.glob("gemsterminal-notifier-*vendorterminal-notifier").first
    rm_r(terminal_notifier_dir"terminal-notifier.app")

    if OS.mac?
      ln_sf(
        (Formula["terminal-notifier"].opt_prefix"terminal-notifier.app").relative_path_from(terminal_notifier_dir),
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
    assert_match "fastlane #{version}", shell_output("#{bin}fastlane --version")

    actions_output = shell_output("#{bin}fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end