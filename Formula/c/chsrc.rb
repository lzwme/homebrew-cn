class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https:github.comRubyMetricchsrc"
  url "https:github.comRubyMetricchsrcarchiverefstagsv0.1.8.2.tar.gz"
  sha256 "bc2a6f6c83c751f6ad4f7d9f25ea24bc0fc269ac765f8e96ce5b89be2ef0d120"
  license "GPL-3.0-or-later"
  head "https:github.comRubyMetricchsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08c46e6a2131d9d4fb56b521ee21bd5a58ea1a98105088eadb5c9ca493517dd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e84a115a9621004db453034e3a4ba3d63af5c24ba185e7e7aeddb856b714f488"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54896e490041dc31baead0d87b5e5493659d87f34d8d62e13e3550596c59bada"
    sha256 cellar: :any_skip_relocation, sonoma:         "659f7ca2d13b4affbe1ca34716f7f49eb70586979fa528c4a3e392617683fba8"
    sha256 cellar: :any_skip_relocation, ventura:        "acf7c3007248ce24b99d2aabf63a8fff1013f680401c07e08a9d10b6e72c1f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "74248b885f92378743cf11593dc36d2c2a7863f9b348876d687b2eae66f433cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19617aaf83ccc4eae94bd21b0712733d70184c5b08bae5a057d2963e1bd194fd"
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