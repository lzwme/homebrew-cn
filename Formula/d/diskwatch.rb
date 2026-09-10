class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://ghfast.top/https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "d34cf4dee599b0ceadf682118267e161f34955bd74aa5108b3c04276105fbfb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "996c75329b76b25683ee0846bae323f17717eae7df5247a72b95e32fa8142f69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c4d6ea89cd2910cedeadfaf0c3baecb4693a9fbb09f81063d0ea297b47c7faf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9fa55b4154a06c5a6fa4f26cce550c023232452be1d211ee70c5dbc5d636fe9"
    sha256 cellar: :any,                 arm64_linux:   "1c4312bce4d9cc3a5fc8afd6d499e8ff2bb1115585955f3bf12af6f71ff893e9"
    sha256 cellar: :any,                 x86_64_linux:  "e12f940270ee5b3b0981e64862764edfdf7e9be0b95febebba44b29fba5226c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end