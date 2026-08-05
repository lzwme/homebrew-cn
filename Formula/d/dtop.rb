class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://ghfast.top/https://github.com/amir20/dtop/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "60fed9214c87a48079811d99d3a5774bf2d0204665b893631950d117c410afe2"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e7ff6b5241f34b95ad974c711e201c6b5656c99dbcb404c7ba11bcce72e85d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2124294ebe3053259000a68e834b9680f813ba2cdf24df528296cc9811bea47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fed8a04b783a5df5214c1bd90bb9479a585bbdcb8aa6b6a7fe951363d757466"
    sha256 cellar: :any_skip_relocation, sonoma:        "425d89452c6831024625bd2c070f6b8a82a5dcb9044822bc7b0fe64730cbdbe7"
    sha256 cellar: :any,                 arm64_linux:   "27a56d9ed02ade5b345403c18ce0a8aa6d8799dfbcbbcc62cddc559c72f0faf6"
    sha256 cellar: :any,                 x86_64_linux:  "e6575bebf123fe9727142d610a38df8d10a01edfc6a4fb20e6bc7a5083fbb16d"
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