class SwitchaudioOsx < Formula
  desc "Change macOS audio source from the command-line"
  homepage "https://github.com/deweller/switchaudio-osx/"
  url "https://ghproxy.com/https://github.com/deweller/switchaudio-osx/archive/1.2.0.tar.gz"
  sha256 "5f5c28c805108666abcb6676be80f01b9ea699f2946aef9f4876ecd0150cecdd"
  license "MIT"
  head "https://github.com/deweller/switchaudio-osx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da2a612f01ce8fae3a6eb693eb15eb76c4c9339ff41e81ffbdbd192136f17568"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "603e97346a04b22121dba84f440b5f8404fbf6869730f670c299bc86de2d50a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5645403020079f9b72b767f71d69ef6ac3c6d86b1624b3033008668ecc96fb9c"
    sha256 cellar: :any_skip_relocation, ventura:        "19f126eaaf57e3c4256edc17c5232f13cd30cb23723b3516a1964035e7e39f7e"
    sha256 cellar: :any_skip_relocation, monterey:       "326a79e597ff28fc9b7c33330a243f24e405df96575b3982f05b694d7342cb96"
    sha256 cellar: :any_skip_relocation, big_sur:        "77c56a2b3a3dba41a19dc6ce73beceab37a7375081eebe9937d77a2a29cb9a91"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-project", "AudioSwitcher.xcodeproj",
               "-target", "SwitchAudioSource",
               "SYMROOT=build",
               "-verbose",
               "-arch", Hardware::CPU.arch,
               # Default target is 10.5, which fails on Mojave
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    prefix.install Dir["build/Release/*"]
    bin.write_exec_script "#{prefix}/SwitchAudioSource"
    chmod 0755, "#{bin}/SwitchAudioSource"
  end

  test do
    system "#{bin}/SwitchAudioSource", "-c"
  end
end