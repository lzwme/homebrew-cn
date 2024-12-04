class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https:chuck.cs.princeton.edu"
  url "https:chuck.cs.princeton.edureleasefileschuck-1.5.4.3.tgz"
  mirror "https:chuck.stanford.edureleasefileschuck-1.5.4.3.tgz"
  sha256 "bba453c3d9ec0c10f04fdc87d5bfb3bab98961a891c8cc88c32827de5cc35d11"
  license "GPL-2.0-or-later"
  head "https:github.comccrmachuck.git", branch: "main"

  livecheck do
    url "https:chuck.cs.princeton.edureleasefiles"
    regex(href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f4f90e9f46e05b9af105ef30d64285930c71cc2012a93f8f726b1c09dae0d70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f31cd27f5675f89645cd25574691fcbf2cad6cb667914eeee8e54ed46495859"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "259ecfebf4c254e2862eceab1f5282c330a119d383e029fac3f74c4657b52b85"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa26945ca827e31b4d9780bb8cfa0aa3fe55d3b3e913a47d5f987be3c059d38e"
    sha256 cellar: :any_skip_relocation, ventura:       "8e4cba57a9f7dee76f85f6b863ac4259e56a3e765822a4d0494640072f00b805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ba850f582440587b380ebc7029e3d48a4c9a1f51a0a9d428dd37119e2e6c213"
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