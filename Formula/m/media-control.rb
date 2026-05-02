class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.7.4",
      revision: "742956858899980b37125d5e99e8d2672ff6ab8b"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c20d668c0879c0a3aff9596468caab88ccaea29a3052ff08a4d7dcd7dbbf463f"
    sha256 cellar: :any, arm64_sequoia: "d1de89c240156b80df2577f6840784d8fd207ed08c415d6f00bf845af8acb843"
    sha256 cellar: :any, arm64_sonoma:  "cd80eec58f19427267d69abee4346d1c808ff12b0e358ea37c396c33d62f6d9d"
    sha256 cellar: :any, sonoma:        "4bb31b8dc29efeb05b8d77c7a98dafcd31609b9eabc87a25a457c20a3e7b0d09"
  end

  depends_on "cmake" => :build
  depends_on :macos

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/media-control version")
    system bin/"media-control", "test"
  end
end