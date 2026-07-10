class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.12.10.tar.gz"
  sha256 "52dff7d2e772c06bd3a790b555f7f0b0491c5e34f6f5252887b855b8dd08e9a6"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60c5de1cef377bf95c43d6ac26bc93ab0faf0f4150ef17e4e13ef8c0641860d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81258fda30846438f790e60719b5039db7efa47f6bfaba14ae4e97701b3b5e06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e40e7685b9683b6bdfc95919a4b55cbb9c3d0274d5a3cfb4211f7fa9c0a3851"
    sha256 cellar: :any_skip_relocation, sonoma:        "3186a897a2d655d3b0b5ff0e8d37e756ee1a0223c2978865fa96d59a0f7de073"
    sha256 cellar: :any,                 arm64_linux:   "1f6d6ce4a8a1965ce535a4f0611b4cec755ff61209accc836e3a11b2dff952c6"
    sha256 cellar: :any,                 x86_64_linux:  "e7ccf748d5806b933a0d3e17094b8c92af43ed1403b5da1ef33e283fd87a2911"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end