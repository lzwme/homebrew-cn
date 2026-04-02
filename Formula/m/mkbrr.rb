class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://ghfast.top/https://github.com/autobrr/mkbrr/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "f071ec9bb77bf56b5971dcb2ea47a2764b61d5778f064d5b052d1200fe6967b9"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f450012cff626c26eaf57321c18f0df45cce14727095efa61fbae73e98774b70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f450012cff626c26eaf57321c18f0df45cce14727095efa61fbae73e98774b70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f450012cff626c26eaf57321c18f0df45cce14727095efa61fbae73e98774b70"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf9d72f6da9e708b3e7c77630c8f8f8c03dcc20453f6097d33bd0be901011330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87fe05e7adbf14ed8b3900bbf16fa22520c7bc56f6aa8af5d7057b7d25e9338e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ec2cd7522d708b010ac516c7776f374812451e5da22ac8433777fa9b21a281"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.buildTime=#{time.iso8601}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")

    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end