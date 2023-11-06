class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://ghproxy.com/https://github.com/bensadeh/tailspin/archive/refs/tags/2.0.0.tar.gz"
  sha256 "dcaaedcf671f971af4b400c0387859d41dcf93cedb6741ff07ffe1c2255ab110"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60e099ab8108982758e7b3c90f10bd6fd057a3275b853fb6e19e40d8b7c0061e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b89e58c0c36f701ff031406424b2760858d9a739b11cd5c77826cd6254e9f95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34099b8dde1dd629c5e035aebbd0fa79ce8b5a3d5efa90a469a22d3b68b31091"
    sha256 cellar: :any_skip_relocation, sonoma:         "983e7e48d7030f591218fbee556d0026511fe8b33344b99acb6649ce9f77a7e6"
    sha256 cellar: :any_skip_relocation, ventura:        "d3e512046d1588a2684528f42edb0a0a3902cc53d68fc3e6daef6d4c6cabb3c9"
    sha256 cellar: :any_skip_relocation, monterey:       "195f47a5c6216cbd4201b85d0269748242a39e5f95f36f1240568b2d6dd15d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08d36b7d240170e4d9bd095a621a1e9185c63980b2093338c72861f4453aec5f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/tspin --tail 2>&1")

    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      "Missing filename"
    end
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/tspin --version")
  end
end