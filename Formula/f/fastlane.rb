class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https:fastlane.tools"
  url "https:github.comfastlanefastlanearchiverefstags2.225.0.tar.gz"
  sha256 "1cbe6d1f65d17df7d6e546d7c44539c7859258d9e0b1d879c2a5cad8418a17f2"
  license "MIT"
  head "https:github.comfastlanefastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "805bae4e856bf2a7f0b05284289c8dfc76cf11703a412f75c2bd2804b85d5d78"
    sha256 cellar: :any,                 arm64_sonoma:  "7b570bcecea27b77b5de28a9fb65f1545d6d27bfe5b83177f710a87bd7d73cf8"
    sha256 cellar: :any,                 arm64_ventura: "f5db0874063e06dccbacd9d1d5876bbb627d08078cc41d455f761f7f175c4230"
    sha256 cellar: :any,                 sonoma:        "0f5095a4b24d968b240a86635b5f39300e4d7cb2c426f33af58f5d918ff86b96"
    sha256 cellar: :any,                 ventura:       "e94980094df1d1594a6ff171ab5dd7f36507e24e280e20ebb5c27bba2c9bcad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c3feaf6d6c7f7130224712f8e0108531f5cf908c14f8a34cbff193089473510"
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