class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https:fastlane.tools"
  url "https:github.comfastlanefastlanearchiverefstags2.223.0.tar.gz"
  sha256 "53acb925505744d2daf54eaff0daf4eb0a36af5a97b8cd94b244d7088ee920f0"
  license "MIT"
  head "https:github.comfastlanefastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a489e0ca80c10da197fe2af80c7b710e8894c33c49d196350bca0aa86ab93771"
    sha256 cellar: :any,                 arm64_sonoma:  "4a2e5db8fbaf3f36c3e64ac7087c0ea3ab4ad1a81baeddf3d0ca5253dd849de0"
    sha256 cellar: :any,                 arm64_ventura: "831942870aca6c3f8ed848cebc1e3c263edc5bf02ffac3e9a17a28a3427e5a04"
    sha256 cellar: :any,                 sonoma:        "7606a31a34ee95fd4dd25dd465e7f49d64c8943554c3917a44133635d056da89"
    sha256 cellar: :any,                 ventura:       "46732dd959211c49da088bb829d400de21ec3f4b787c3666f450ad409f5b0361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dae02308e4cdd4acf13054fcada6c013a49a75a3134f78225572c0f5e049939"
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