class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https:bavc.orgpreserve-mediapreservation-tools"
  url "https:github.combavcqctools.git",
      tag:      "v1.3.1",
      revision: "0573c33953d02db53812a2420f174d6b1233751e"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.combavcqctools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "74f2414ccaac5d53bb8b4649f36df6a1d71affd563f9659a2234ceb0c81805ed"
    sha256 cellar: :any,                 arm64_ventura:  "d6f507f9162b5c0efd05e676beacb4426a17b6aa910919310f5c451483900277"
    sha256 cellar: :any,                 arm64_monterey: "63948d79ec70c9d0508708b7d9c646ce56730577af431cdf5aa9dd362091afe4"
    sha256 cellar: :any,                 sonoma:         "ac8d5ce426a89238dfdb40d584e3af8cd275630b467bfc6e5dbb06407a0d41c3"
    sha256 cellar: :any,                 ventura:        "61cc358cb9c4afe330d4b2639c990d90c76837f5b788279ec81df02eb61d3ce3"
    sha256 cellar: :any,                 monterey:       "12bf0f711da97afae0e9cffd4eee084c95fa50b9a7945334a6aa62a010b5c145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14e72317eceef670be0d732541e176f143ffafc616cb698dc4052b5c1c589c92"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg@6"
  depends_on "qt"
  depends_on "qwt"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV["USE_BREW"]="true"

    cd "ProjectQtCreatorqctools-lib" do
      system "qmake", "qctools-lib.pro"
      system "make"
    end
    cd "ProjectQtCreatorqctools-cli" do
      system "qmake", "qctools-cli.pro"
      system "make"
      bin.install "qcli"
    end
  end

  test do
    # Create an example mp4 file
    mp4out = testpath"video.mp4"
    system "#{Formula["ffmpeg"].bin}ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    # Create a qcli report from the mp4
    qcliout = testpath"video.mp4.qctools.xml.gz"
    system bin"qcli", "-i", mp4out, "-o", qcliout
    assert_predicate qcliout, :exist?
  end
end