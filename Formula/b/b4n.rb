class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API written in Rust"
  homepage "https://github.com/fioletoven/b4n"
  url "https://ghfast.top/https://github.com/fioletoven/b4n/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ed96695f179e9c5f494de3dddbf2516b9cf8aa8b14a67c44e44f116401202de1"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e876dd54c27dddb46a31fbc96e78b3a1c6215d81384c560407bd6e66f235bf85"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d8d897557f72b706d5117edab7f2ce07637399f13a4e74cb22b21819ed17c0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "22956319d75a2467a5986a7b446f29fdd58d5c561ea6d88e9b589836950fa679"
    sha256 cellar: :any,                 arm64_linux:       "9b57336b2f66a91f05fb925f0cb4d2d6c3f88fbf9bd2fb8887547fac0bf5953e"
    sha256 cellar: :any,                 x86_64_linux:      "5286410524458e97acc19c47b7bf957166e63bf6cb38a7d160179a0668111f9c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # a cli will complain on incorrectly configured kube context or config file passed
    assert_match "Error: Kube context 'none' not found in configuration.",
                 shell_output("#{bin}/b4n --kube-config=/dev/null --context=none 2>&1", 1)
  end
end