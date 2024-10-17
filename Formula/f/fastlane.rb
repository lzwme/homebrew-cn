class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https:fastlane.tools"
  url "https:github.comfastlanefastlanearchiverefstags2.224.0.tar.gz"
  sha256 "148b0327bdedd4e48c492224fd58182abcb904b690607420b70d4747d2979186"
  license "MIT"
  head "https:github.comfastlanefastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ae7aaf447b52b3dc9a34dedd3808590c391a38fd6e2e8148294f9be549c34a07"
    sha256 cellar: :any,                 arm64_sonoma:  "0de7e45d5c9355699cc3733fd9e810d48f9055c65695fa073683ca7cfb4ed75f"
    sha256 cellar: :any,                 arm64_ventura: "6083d15f2a7e7a1066c0114999bf5053ed2bb404285ed5f16c54e75e14a95584"
    sha256 cellar: :any,                 sonoma:        "a9ac836d92b2e5a3afa541f979901e37951be559d293db9faea7f263c02ec006"
    sha256 cellar: :any,                 ventura:       "c974c2e6cbf21debf65f7f49d3b2309021e82ea92ae85f68148608a66996cdff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7ed9e7378926a0daff58f1535d454a7f249cab733e59fbd63f262fa7dce2cc2"
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