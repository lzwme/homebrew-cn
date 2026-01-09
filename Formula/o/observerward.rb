class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://blog.kali-team.cn/projects/observer_ward/"
  url "https://ghfast.top/https://github.com/emo-crab/observer_ward/archive/refs/tags/v2026.1.8.tar.gz"
  sha256 "bf6d8fdf3d6611930d6fa25afe179a9283faf1eb104d388b9fc1638c769a7928"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cced63f50db35ff90185184740ccb2ad11b05c7fa0f44757face8b5ce05caa3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "767d58d929782840f8b10fa5d0a4d39795006c4e64e20998c2353a31a8705714"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14d24494e0d69cf28a42efda57b46bd0b2ca56cba8f9b853f4c295e642a05e69"
    sha256 cellar: :any_skip_relocation, sonoma:        "bee2cbae1c9ba0665c8c25dfff4f13208a626c2103685aa7f1bd277189d9852a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a87dd2a35335d1a805e5dee056721f6fe65e81349ef50df6ad8131198007dd08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e7eae4602562147a12b01e607c562499e691b2a85fd9201c9ea6b1d50bb257d"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end