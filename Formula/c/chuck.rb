class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https:chuck.cs.princeton.edu"
  url "https:chuck.cs.princeton.edureleasefileschuck-1.5.4.0.tgz"
  mirror "https:chuck.stanford.edureleasefileschuck-1.5.4.0.tgz"
  sha256 "e54b2911ba973af263f6d75dc76c67125d3dac1174eb0fc8a74e4c103469f653"
  license "GPL-2.0-or-later"
  head "https:github.comccrmachuck.git", branch: "main"

  livecheck do
    url "https:chuck.cs.princeton.edureleasefiles"
    regex(href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "090d47f6c400c7ab8b052d1ad54f414097bffa035eef65c2165376970c15141f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13aeec37aab73a4c6e42a3844ebb586cf628eab4dac2da6678ebb1c461701531"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a4720b44f24104809122cea5ae9baafe31f347708c8f1b70ea6e5c2b9979c5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "67e72554378db4b7645a8d9e9dc3bb32471169392aff9b8acfb64b28f04ae1e3"
    sha256 cellar: :any_skip_relocation, ventura:       "ebf345bca3754e178e1600ffd3714e47c61e9f86371a2b333664c52c51566a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfa4723a9200c5fa4974a9d626409edeb80daecd49e48d44e20fc885435f8a1a"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
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