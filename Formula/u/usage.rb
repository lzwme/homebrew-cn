class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v7.1.1.tar.gz"
  sha256 "9717fbd8deb95b7bd16520c485cc8463bde7bfeffe78e1b1a2c247a5537f4914"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e697c21f3504ad4bff3e7ceb80314e3703279ca16a844176a9f0f252027d6a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c2dd8d74d9424873004a21601ce61a3d8224e25b8d8cfa831dcf5ed98d7964f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "913553855253fdd27493db6d8a7f67fc42e61b1077ff8ca52d383071b9eb9bf1"
    sha256 cellar: :any,                 arm64_linux:       "02643d3c2422b44175c36289175602d1bdcb73eb387bd0dd03b2e0a315baf0cb"
    sha256 cellar: :any,                 x86_64_linux:      "1a62cc9b9ee722ff71bc9c1ff34b2d9a6a408ce6862513436543d1701bc60012"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end