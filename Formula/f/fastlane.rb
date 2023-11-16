class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://ghproxy.com/https://github.com/fastlane/fastlane/archive/refs/tags/2.217.0.tar.gz"
  sha256 "e66a2c45b9a44c352ec20dc9e1846345110fd20d30407cecd5739651824c8c15"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "373a0052913bef4adce931af403de7d1118f51101dc3505b6f724e32e0fbe3c4"
    sha256 cellar: :any,                 arm64_ventura:  "a11ea22a0e0bf201aefe2463b7adfc628d901bf2acf69eccae14c9586e8f9156"
    sha256 cellar: :any,                 arm64_monterey: "e4a7f20348285aa36ec9ecf5822bef9d8b2f1674deadca6571e24ab6cbd214aa"
    sha256 cellar: :any,                 ventura:        "996a9b90cffff6a9317c967765c01e6144bc6a67b0570a672586ae7493c33af9"
    sha256 cellar: :any,                 monterey:       "220814f1a7340071ecbbf7980ebcf2e6d09e19df116beec12cabeff061b1a952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2592c13c7abf7e5f0089531c6a6a58608bd447e07a53d8d4531da80a909e6bfc"
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