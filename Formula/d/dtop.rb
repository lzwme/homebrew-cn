class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://ghfast.top/https://github.com/amir20/dtop/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "ca8d6f75760a9e9d9d45ffb7c64c4469339a92a0f8e112be00a30ff64fc969fd"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e5a90e2b802cb3cd9d68bd109a3fdc9e33a67c799d4c8df29f6b54d14b02b04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f18716256dc42b7998a6fb576286b9dd64a0f06082c9e662a6ffb60c97cde529"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31c57b9a245fc6505f713dd5e142d50177598fadcc9ebd52c8ba1d5c4d8baccb"
    sha256 cellar: :any,                 arm64_linux:   "5782745a2e39bff8cbb53d27e2c76bd0228b7f58fad7e7d2598f37b796fc9832"
    sha256 cellar: :any,                 x86_64_linux:  "95281c7a11e8e00233f69b915910841523b19bae9d2101e83527e2e6ad821c3c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end