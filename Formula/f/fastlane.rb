class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://ghfast.top/https://github.com/fastlane/fastlane/archive/refs/tags/2.236.0.tar.gz"
  sha256 "2b6f5a88acf6947b95cbe7386eb0ed370ef95aa2c9df9acbab70021857dffa34"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6805a42de9cc3d2aff37dedc1695d1c0367e727a0e05284b392a46dc7b9d29e9"
    sha256 cellar: :any, arm64_sequoia: "9e25558299511a381007d1533cd2b25abcac04cf075130fbeca42023dd6ab2d9"
    sha256 cellar: :any, arm64_sonoma:  "020d80c08c422bec614bca9ddba44c22ba969ba785eed75e50cf00bb167b5dd5"
    sha256 cellar: :any, sonoma:        "61f4ace522860f414ef04a4ab7ede8f097b005adb3ba1332bf56823c72ede42e"
    sha256 cellar: :any, arm64_linux:   "7935748d99c0eb6f697d0cacab660fa1842e9a83e36b1468d18eda563d104b98"
    sha256 cellar: :any, x86_64_linux:  "d6e2ee738fafbc71b81d79a2ba3829ed7485f7c94838583fa58768ccbdb72a0d"
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