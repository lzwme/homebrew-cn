class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.5.2",
      revision: "23ffe27f7ada86dd7ee87e870256d6e3497a2114"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "fb5e79d689bd1701708612ec373e33e78831d8f278818b4b9707b5a6eb251d9e"
    sha256 cellar: :any, arm64_sonoma:  "ea9b01ef2c2ada5331eba5b082a547c1ff91d5324c5b401d4febba7b45f869c7"
    sha256 cellar: :any, arm64_ventura: "a45afc30648446056b4ee49c22d46b9f90620b07a6dbe1e6ea474b5e7c72dcba"
    sha256 cellar: :any, sonoma:        "ac33212c5dda8b8491bb92707e1757981ba66029fa79882976b1b7c87688989d"
    sha256 cellar: :any, ventura:       "04394d06252f323c5fb5998f0da4aec5b441cdc498cfe83eebddc12581d6f0a3"
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