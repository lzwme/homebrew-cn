class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://ghfast.top/https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "35c738fb13625daec67495b7c5c0966e1bb05251c9bddbb14a5e4c9eab0008ae"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60b270ae250808a5d2841716e50d178af0b2306ef3beb747a3f53cc4aeb194d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7f750caa4adcfc79cebb7b672159fc28632291b470211584a9625c3c1bcd54b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efd19630f8133056f068116c51f093c7dc4c278b4efff1c105cc316a78e1ae49"
    sha256 cellar: :any_skip_relocation, sonoma:        "19f9e5ebd43f2a0d7ec9774a509bc4abcad6e62a4e23418f154ab06f370fd048"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "027f495c5a11273e77db83f6af974e3479a909899c77eaa38ada95c3bfe9e9bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f39ba21a7733c49b455b98a19d2fbd78002bdada3f18102bad97f5784efcfd82"
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