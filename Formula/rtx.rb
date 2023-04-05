class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.27.11.tar.gz"
  sha256 "c47b93ca4855d01f3b99d9d58775b86b1e2f095ced537e68059870259ad05b0b"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb0810c2c6d4709da5cc7f5bb6696326532480e435677e23aaa1f43e713475a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a439de2d763e25c4197bb3119d8f047bac9ae6a7c612462acf8256d053c5ac9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9842eb22bba58746207ed82ae827384a511845b80bca3798d1aa32294d2ac14e"
    sha256 cellar: :any_skip_relocation, ventura:        "57126c2f0868e64d0bb93b8aadf6e5941d2ca3fa0e5ed8a029e532582758288c"
    sha256 cellar: :any_skip_relocation, monterey:       "25f98d98a7d0522e77b8beb98e3d8871459c2ba48d9843d561935a407326a23f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c71d939df62922ff8265ed38172bd86991260ab9158bf5835dfc8af9853b84a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c13ff0389725cb7810b2d173bc4dbab6e2f2dace08c6fa159d95b2c84fa72009"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end