class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https:github.comRubyMetricchsrc"
  url "https:github.comRubyMetricchsrcarchiverefstagsv0.1.7.tar.gz"
  sha256 "cc9ca0f7cb73772680e80980e34ae62cba77b3c50a3f934383b24597bf6050fe"
  license "GPL-3.0-or-later"
  head "https:github.comRubyMetricchsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd429fcb7c982e057d13ed96d0e5aa1fc4046433b919c3f03eb61991c8fa63cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8c09a20e98450343813431af539797d1f847965fb651ff343f4b696095fb6a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fddc2d216ebb2460cc2ac7f3dd7bb9850dcf2ce83fcdf18d9a14d25672d69d63"
    sha256 cellar: :any_skip_relocation, sonoma:         "633351fe859dafcfa9c9a47a5b4442eed4b7178d566675fe4a123b3bc2aac1b8"
    sha256 cellar: :any_skip_relocation, ventura:        "9e48fe72ceca794640e782eee54e151dbfeba0939c4640373f4789484dff134c"
    sha256 cellar: :any_skip_relocation, monterey:       "55798faf8bd57a0d1a7a561dcc2c9723ea95f0fa90683d47b435d832692244e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e03b6ec7539f66810fa2995afaf67195fc0ba63360b77bf656799024f3b821dc"
  end

  def install
    system "make"
    bin.install "chsrc"
  end

  test do
    assert_match(mirrorz\s*MirrorZ.*MirrorZ, shell_output("#{bin}chsrc list"))
    assert_match version.to_s, shell_output("#{bin}chsrc --version")
  end
end