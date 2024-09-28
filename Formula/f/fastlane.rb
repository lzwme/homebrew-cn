class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https:fastlane.tools"
  url "https:github.comfastlanefastlanearchiverefstags2.223.1.tar.gz"
  sha256 "870a1a8bd8b28405d90d3668ef927159b0a710baf814d44451dff1eae38c399c"
  license "MIT"
  head "https:github.comfastlanefastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5bad04a0131567f193e23ad6576eeb058461ccacd8831f0f3591ed11ad9b0792"
    sha256 cellar: :any,                 arm64_sonoma:  "1afbaa94e761fcb0e4cf46f770236d06e92a0804219e4996fd6fda4753a30203"
    sha256 cellar: :any,                 arm64_ventura: "83d04764a5e541735c28c853923507e090918a0012d201d9c08b717f1f41229e"
    sha256 cellar: :any,                 sonoma:        "a228da8a003a0c354acdeb7492916385e644855dfee085b55b7e63aee91e8122"
    sha256 cellar: :any,                 ventura:       "f3c7b600b60a216e05dd6cc703a8232e4eaad304c3dbeef7b1498d5c4468b31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0abce9f56300ab516107b53c8235d49d7bb90952dfa3bc4623a528ec36416a97"
  end

  depends_on "ruby"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin"fastlane").write_env_script libexec"binfastlane",
      PATH:                            "#{Formula["ruby"].opt_bin}:#{libexec}bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        libexec.to_s,
      GEM_PATH:                        libexec.to_s

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

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}fastlane --version")

    actions_output = shell_output("#{bin}fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end