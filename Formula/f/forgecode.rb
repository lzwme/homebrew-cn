class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "5f0d2d227bb213295048b7041b823f884e3afc643149dfbb8518ce492ffd1598"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d25b9e2409e75048a5058087ebca3063df9a52661207d3cddc344211be7e3098"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebdb163bea16a6b775cdb9b7671ff8e1589b93d6a6fc97636193735ef429c1f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e57f65e9d4288ff6b89ec5568b8f1e90a979fd2b60f1f2221e1202353d3316c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bf539e67b6745761e2f9c026f57fa586d4f06be0ea85c495e381751585498c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "179f6a9bbce681ece163fad86cf81a13a7fb503a9a93b8684f41a0bcde076dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5024a524943417a51360c12612d8c059f1fb8cab83fd2a7b3a7335955a142121"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end