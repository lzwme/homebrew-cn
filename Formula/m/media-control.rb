class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.7.1",
      revision: "866b31878f38ee41f6e2583e2f6057449ebaf154"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "931670d165d6b616639e7e288093fd6f148d2d6cb2a65a2246a724b7b1640e3d"
    sha256 cellar: :any, arm64_sonoma:  "9bb4e867cb4d2f62decfd9f520129c79f429a5e872351a83175a6edf1da40123"
    sha256 cellar: :any, arm64_ventura: "ed078baed3cc472b0ba0510f59254c87fe2210df559d8095434ce22107d9f007"
    sha256 cellar: :any, sonoma:        "3c2a41308f8a7ee885d49c0290c875645dca0c097f7722002e802ca414f538d9"
    sha256 cellar: :any, ventura:       "f32259e2798a9339032a8600d4d33f713df86fa3eb0bcdaae96aa2f2223160bb"
  end

  depends_on "cmake" => :build
  depends_on :macos

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"media-control", "get"
  end
end