class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https:github.comRubyMetricchsrc"
  url "https:github.comRubyMetricchsrcarchiverefstagsv0.1.8.tar.gz"
  sha256 "75f2ba4e792b1e72671b1144ac4bdd58c38db59a948349f266c65a4d022138ed"
  license "GPL-3.0-or-later"
  head "https:github.comRubyMetricchsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40fe3194393a04b1afea60fcd87d1e31d8ff1b40a363a8afc41481b04f2a818a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "638fe9b816240122b375c9bca9fd8f6ad72b2b26ee346f3f3d718a2624ac93c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a8604d2b2742e7b921f0253c92f63e30c8f3b1cb4f7090caf5523144a310640"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c0684b5346878f34bae73f0345b3b6de2c792950d94cb337b6fb65979fde294"
    sha256 cellar: :any_skip_relocation, ventura:        "d29320f006854517988cc560c6368696928947420d483a41af194e144bec062e"
    sha256 cellar: :any_skip_relocation, monterey:       "730dacf6220ead2ed67374a0f60c077613e88098c28c42d7d313384ef9e3b0d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cb73ca26d6ed94970158b66c0e5d8e16250048e2b1f6063c3fe7662222b487a"
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