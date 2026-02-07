class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://ghfast.top/https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "f54d965328fe298a491d22508e054cfe2b12ba303112069ecf71707930fde0cc"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfeb18793da0873fd7f660047a8deb2a505464b93ae896dea5fc1937b6914206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaa2df6ada9f619ff5adb14b4f2238ae85bbb835fe407d907f309098b51a540a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7700de475a0da051cdf6b90a7c425ad8d4c5dc6f0712bf35bc1c5e8e94b19f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "683dec1d9598241066d1b71b82744f8a6cb615c5c948c16c74b2205d8b7ea828"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e00a6aa410433d92f27e47bae8538561487ece83986c3194468769bf9185feee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8e8e66e652d323671a7f082981fa1629428b9da9b10cc9ca8ac1a62407aefb3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["HOME"] = testpath

    pid = if OS.mac?
      spawn bin/"bookokrat"
    else
      require "pty"
      PTY.spawn(bin/"bookokrat").last
    end

    sleep 2
    config_prefix = if OS.mac?
      testpath/"Library/Application Support/bookokrat"
    else
      testpath/".config/bookokrat"
    end
    assert_path_exists config_prefix/"config.yaml"
    assert_match "Starting Bookokrat EPUB reader", (testpath/"bookokrat.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end