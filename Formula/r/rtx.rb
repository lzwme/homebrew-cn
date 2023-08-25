class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v2023.8.7.tar.gz"
  sha256 "7beaec0e463eab00be59bd828053b2b7c38075e30880a4adb8246844140f13b7"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd5d805643fb8b9b2adc0322d03b955d714e80bad8d716864bc821bad3d5d942"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "352dd4031046be3ddbe5d951c495a04d7abc226335f166fe6a02438cfc135c3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b588afc8d5cfbff549698f6fe833004ee06406f64fe9f05acc058afbbcf9aacb"
    sha256 cellar: :any_skip_relocation, ventura:        "57895cba101b9e535734eb4ff6a1e178c5ade88116d40e6dd3553df463392f5d"
    sha256 cellar: :any_skip_relocation, monterey:       "6c88685a39809929a7c02d096671ce3d69b6ad85ed40c2e6af7a311bad4a3376"
    sha256 cellar: :any_skip_relocation, big_sur:        "f002bf32abe1fd2116ed20abc3c8404ada57f617a0f78d2b538f99252a38ef24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7e6d1772341382f6eb13b8071f8183ce8752a42e9bb827c1acc26c2f5bc3237"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

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