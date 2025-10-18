class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://ghfast.top/https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "c40dab4c2e4c1e4444a277b5ac77fff38afb474bbaffc0b057f973c20e114c8f"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bbc0fd8c75d1705f331978e8110e00bfe5537b8639aba02b8fbd8b9e3da880d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45b212bd167cdf293f25e42b6f09e06004f6008890ecc3b09de941fbcb2ce107"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "299f484aa2fc84fe0fdb0813472abeb598ac755a1c7e0a04fcd2b4cac70d7e55"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd45d47fc242dea064fee61afcde3c009a7cff857950b8b7db6056cfcdfd6433"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "450126379d02d9d52a19962976bb86ac5cda9de901297751f6471e93eb86df39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c2087864e5c1c096cb87e044d1ccace0db515bfe018818d51783a7c90bf89a"
  end

  depends_on "rust" => :build
  depends_on "libusb"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/cyme.1"
    bash_completion.install "doc/cyme.bash" => "cyme"
    zsh_completion.install "doc/_cyme"
    fish_completion.install "doc/cyme.fish"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = JSON.parse(shell_output("#{bin}/cyme --tree --json"))
    assert_predicate output["buses"], :present?
  end
end