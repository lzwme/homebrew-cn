class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https:chuck.cs.princeton.edu"
  url "https:chuck.cs.princeton.edureleasefileschuck-1.5.2.1.tgz"
  mirror "http:chuck.stanford.edureleasefileschuck-1.5.2.1.tgz"
  sha256 "7a8745e9e63ff8be3c0f31c4fdef326993b3d5d1871205fde3ff8e9e16eb1ea2"
  license "GPL-2.0-or-later"
  head "https:github.comccrmachuck.git", branch: "main"

  livecheck do
    url "https:chuck.cs.princeton.edureleasefiles"
    regex(href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dab5596335f7518472d59394a3e6ee33067cf5de3dc1705ba92d97348190f06d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dab5596335f7518472d59394a3e6ee33067cf5de3dc1705ba92d97348190f06d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeb8530fb1c281f897ec79d7b7c34c8b9ad8abd07bf695c4237d4215ce3e4e89"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e4514426ae9b93a16f8d310e28eb45b55e7f9265c19e6060dc044d9359bb2b0"
    sha256 cellar: :any_skip_relocation, ventura:        "3e4514426ae9b93a16f8d310e28eb45b55e7f9265c19e6060dc044d9359bb2b0"
    sha256 cellar: :any_skip_relocation, monterey:       "e4e3de21a5c613e4578baacdb37d5df90d2b1216d4a966873bec817609f3f135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42a558eabfd22c8c7c7358c33adb58827dc214f513428f66a50475c25abcb598"
  end

  depends_on xcode: :build

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