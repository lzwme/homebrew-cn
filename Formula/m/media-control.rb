class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.5.1",
      revision: "1a4c3f7f3a59c28a0e21c957bc0c9edf4dd00e2f"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2b9e3181f309c01ea8486b28e0d83d5524b3e9d7ecf5ade7c21aff2307775165"
    sha256 cellar: :any, arm64_sonoma:  "51060056b44c31b3eb54867db0883e723481fb8a491bc5166b39b7bf9010b3ac"
    sha256 cellar: :any, arm64_ventura: "64531989913840f77e32198e0d9f986f7141f90f97a2b80c2208bc7209aaac91"
    sha256 cellar: :any, sonoma:        "387029d41be8466ed00fa287611533c7665fe6dcdcfef4506f65bc35a351d0df"
    sha256 cellar: :any, ventura:       "587d3f6827c3f5ed8906074b2d7da23e57aa1764cf71edfee322739a75203213"
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