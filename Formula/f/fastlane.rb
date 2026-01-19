class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://ghfast.top/https://github.com/fastlane/fastlane/archive/refs/tags/2.231.0.tar.gz"
  sha256 "1357db856bd1791a2b3463f1fd251fe2c41f20b6aca38e9510e615880679b5c0"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d7759d0965e1bdefb0fb86a01fff3e5ef7f2e72209776a363d7b6264bf3483eb"
    sha256 cellar: :any,                 arm64_sequoia: "87ab332370905996fee3d7dd9bcd99e53fb05c0e440e9a23f76da29a1f9d6767"
    sha256 cellar: :any,                 arm64_sonoma:  "b0ee9e7161666b790b9a42a28268998859944eb9fa1f6ccd64d9e7fe65bb3494"
    sha256 cellar: :any,                 sonoma:        "396f990983c3da285af8b95a6040273a6ddc7eab38a383d88cf6016031a2db6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc5e68a14f630fd670d93852a7ed64287bf3c4c453f6bf339f97b47e7057a3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "015eda6b32f37476131d288aee339e38f4255675bed18ae32bf701c88a31a3f6"
  end

  depends_on "ruby"

  on_macos do
    depends_on "terminal-notifier"
  end

  # ruby 4 build patch, upstream pr ref, https://github.com/fastlane/fastlane/pull/29869
  patch do
    url "https://github.com/fastlane/fastlane/commit/68926304c713d5f3073c2ec696638045c13060ff.patch?full_index=1"
    sha256 "266f64c493adec094af87dc8a3dc8ff3166f6f0f7bf1a5db471ea987ee10c96c"
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