class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://ghfast.top/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "c19f3e678b758b565c3931a1d6ab4860694cdc9c9bba36ecb580c16a35ab2a87"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7e133ed074955a63c6a8798a61b9eddc29715a58bba8e5b4a7eaa36662c031f"
    sha256 cellar: :any,                 arm64_sequoia: "2ccfdde9bd0df499826ceccf88b8f1fef19d35a918e941f3fd965678251bc4ee"
    sha256 cellar: :any,                 arm64_sonoma:  "b36d51ab316c9ecf3d6df02490e01c38dd045693f1f60e0efab37bff27d6e86d"
    sha256 cellar: :any,                 sonoma:        "01840cf4b5367b8c6b9fb8e1046870b3b8e81b661945b690b38a5c125bcb30a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d1cda6d4d5f9682fcdca2160442f7758b0bc15da9c37826c3e2c7044dbd2b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7df0436b04a6afeefe201c9f4abf9a7ea56a4a6a6d90352328155eb34369b555"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"mdfried", testpath/"test.md", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/mdfried #{testpath}/test.md", [:out, :err] => output_log.to_s).last
    end
    sleep 3
    assert_match "Detecting supported graphics protocols...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end