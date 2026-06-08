class Cloudfile < Formula
  desc "Minimal Management of Cloud files"
  homepage "https://github.com/kevincar/cloudfile"
  url "https://ghfast.top/https://github.com/kevincar/cloudfile/archive/c3ce8c27379fdcda6b8eea93b51e9d505893c135.tar.gz"
  sha256 "034f4d1e4997aadba139891f3a60cec28d3423bfbf12d1865d16847719e280eb"
  license ""
  version "2026-04-16"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/cloudfile"
  end

  test do
    output = shell_output("#{bin}/cloudfile 2>&1", 1)
    assert_match "Usage: cloudfile", output
  end
end