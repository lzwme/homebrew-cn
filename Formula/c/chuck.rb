class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https:chuck.cs.princeton.edu"
  url "https:chuck.cs.princeton.edureleasefileschuck-1.5.4.2.tgz"
  mirror "https:chuck.stanford.edureleasefileschuck-1.5.4.2.tgz"
  sha256 "cc04cffb5b7fc93ca63154324a2787478d47a0992e0590e4c623ac4808294a10"
  license "GPL-2.0-or-later"
  head "https:github.comccrmachuck.git", branch: "main"

  livecheck do
    url "https:chuck.cs.princeton.edureleasefiles"
    regex(href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f761b29155a28427823e52cab266d7c56472cb27d83dac30e260c5b901995bb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6195cc630f7683f5885df3a5b295272872679368cb61530c7c42379f09ac0205"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0df662d6fd4f3ed5a0baf922116806491caf6bd90fb1bb103cd659e137fb2a37"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e5dc5b7a99ab32d10f052c931cea0bc37f552a30689155f6ed98728ac40d90"
    sha256 cellar: :any_skip_relocation, ventura:       "17d757268ea87e7d5dc2253d62ff72907c49bbfec5f6f587595c33ea5e55a431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0adc111316246e9ee239c077948397109c06abd274531e71e6b9fcf9623175"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "libsndfile"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "mac" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "srcchuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}chuck --probe 2>&1")
  end
end