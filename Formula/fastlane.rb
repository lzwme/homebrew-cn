class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://ghproxy.com/https://github.com/fastlane/fastlane/archive/2.212.1.tar.gz"
  sha256 "ea1a726fca8f7b98f0c6703b474e98f5ff40123f23d15740a4ffe783817ed15b"
  license "MIT"
  revision 1
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f1f1e3c958cfe896a73cfa60ab4f171c5803ceb46b63d5a06759763548581c09"
    sha256 cellar: :any,                 arm64_monterey: "38a78f4b6a5dd5e22204928c7fa7e896607916db074453b1e032e9aa48e5f568"
    sha256 cellar: :any,                 arm64_big_sur:  "b6990326f6f901860d019e0ef72b11efa17a938d69b8294a4cbc7d20fa176e7b"
    sha256 cellar: :any,                 ventura:        "3acfdefd790e6805407d44ece1564032e9126d8d062f49de7b3a4d70780be673"
    sha256 cellar: :any,                 monterey:       "ba534bc7d8307229dff07e3384e4a7c0aad0345b69fe53e60dc43aebe3dd9ee4"
    sha256 cellar: :any,                 big_sur:        "701ea6aef9f4410fabc4a098c77e6811a65fad8133d380f38ec1b32af1296e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a75f8400eca46e0e87704ccd04a33c62685d306a2752a192fbda471dd8f7cee"
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