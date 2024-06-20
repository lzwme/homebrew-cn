class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https:fastlane.tools"
  url "https:github.comfastlanefastlanearchiverefstags2.221.1.tar.gz"
  sha256 "4fbf3bfc417575be21fa62fc970471af6ac3b096278bde4260a2031be643ae28"
  license "MIT"
  head "https:github.comfastlanefastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "089eba4be43de20b0d9ff037d9e27489e4108af7b4a53e040261736c847e4965"
    sha256 cellar: :any,                 arm64_ventura:  "50b1a8bfef15559018731f6a29bb101ad231290c0cd5dac28567ea61c627ac85"
    sha256 cellar: :any,                 arm64_monterey: "0fe1a96c1e5e35cede176985563ca6e356e55228976f13d9edea7d8e192d005c"
    sha256 cellar: :any,                 sonoma:         "b7bd0cb7d4f4a5a154368dd043435bf8f58bf679e251170d3e3a4bbe7c0bf5b2"
    sha256 cellar: :any,                 ventura:        "3c87f112676a546969495b75d9ad97db148ccefd43cee29e26598979cf035ac3"
    sha256 cellar: :any,                 monterey:       "dd491b4f988f40427a05c0f181b7fe87140044c8d099097e815c0f1835cf9df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aeccb5c13d06f23482c219540d63db4f36fdf7d6fc34d11c193f5c8e7fec5be"
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
    (terminal_notifier_dir"terminal-notifier.app").rmtree

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