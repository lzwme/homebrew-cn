class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://ghfast.top/https://github.com/Skardyy/mcat/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "4de354c29504d294030183eeb94a0286849c3a02d4ac9253739030061dfd12cf"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e482f7e090ffafae64f34d44177efb930db6ce9c9b4d3c31b5a27d87e29c0e06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f1893d47a0821e850730687066aae3aabe5d49fd282551eaaaab04d7d54e65f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6acdb2571c4f8a19021612398efff2119326b838a1a8edc7ba9967e37a701ea6"
    sha256 cellar: :any,                 arm64_linux:       "bcb106ff0d36dc683c2d816c3b179319e6f3ae743369699675835a4c2bfeb444"
    sha256 cellar: :any,                 x86_64_linux:      "19656eeb14466d246c1d574fb7aaabb856b01148c162c4c324f4756f72f6077c"
  end

  depends_on "rust" => :build

  conflicts_with "mtools", because: "both install `mcat` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end