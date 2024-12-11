class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https:fastlane.tools"
  url "https:github.comfastlanefastlanearchiverefstags2.226.0.tar.gz"
  sha256 "dab7c2f3d8cc47e1bc4ed8b4351a0e1b438c70009bb28f3e352ffbb5c001b1f9"
  license "MIT"
  head "https:github.comfastlanefastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe571ca2e2a756c32d1e1adc0ca1d0613f5355c5dc6da7a559e571e1537b9a65"
    sha256 cellar: :any,                 arm64_sonoma:  "6eb64c9dd514cd6b3a1b15a4ffc552f577be6ac8796df4802ead2dd20c47abb2"
    sha256 cellar: :any,                 arm64_ventura: "5dfae4a9f3d6fcf05990a4d7c17a55a504da57f57de2be2799dce62241b626be"
    sha256 cellar: :any,                 sonoma:        "2a5d902aedf1db8724569bef2445fcf5b66c89273beff7c8940926ff3f9592bc"
    sha256 cellar: :any,                 ventura:       "a86aa6845e7128df6a5bbe34660c1cedbc0cd00a8accc2ebc5976f4d57f5b3a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "971fa1fb2bb46026f9c97c45f4e2848a39c55bd1ef72de16cdf85a890e8b0c38"
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