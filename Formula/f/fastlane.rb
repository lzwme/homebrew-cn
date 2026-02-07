class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://ghfast.top/https://github.com/fastlane/fastlane/archive/refs/tags/2.232.0.tar.gz"
  sha256 "d13602e48dce8b30b716209e09852106cb6d3605ef533e189cfc5747f2d77e71"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01ce83a7f1eab40e32e08faa4c703d54861caf03f6282d06d8d56d9c9d466dca"
    sha256 cellar: :any,                 arm64_sequoia: "e66fcc0bf62e208464880cfc33656369b517c178bd2862634647bd3464333f5e"
    sha256 cellar: :any,                 arm64_sonoma:  "d4b13e3fdce51ea1024774fca880135fbcdd7726351905b49d5cd59b2e13d4c4"
    sha256 cellar: :any,                 sonoma:        "c74745359c564e375132e47488660564b107be670d5540184ea1597e2d1a9e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b39858d5c63eceb6ed9c51a1a7026db0e36082c9fecbd8564dba0fa5cb2dea84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6e37d5f5d6fc3e5492589d00c8297f3ca8f8c043501986db9f83eccc4e01060"
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
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end