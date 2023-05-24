class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://ghproxy.com/https://github.com/geph-official/geph4-client/archive/refs/tags/v4.8.4.tar.gz"
  sha256 "3ca9698a01ad12bdd4d89b1c8b2a1ec6f90fb3281c8ca49118120108b0f1d314"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "921040acf6ffac5a059a80d0b4ceb23b0eeadcb4a28adeaf1bf91f63486caff2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceace1a543ec72c22448124493a93dc44c8444d81885f18925fec736e31e8799"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "711642d121f97d0c3fbb65a602ba80b9e5905efdc947f97df5ae7a8c121efeeb"
    sha256 cellar: :any_skip_relocation, ventura:        "6d4fc435686614dd33fb6326eec0b63d401acf1cacff67dd02770e1d4fbe02fb"
    sha256 cellar: :any_skip_relocation, monterey:       "e28804c7bf1f501f7f77d028b2026a9202a8c1edffa36d735c1abde722ce22f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e285985400f2df8dc5777a6e87bd7e6676e463b7757c439e2aadadd773cad1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2e4c5db5e2d5ccbe73984fb0de844ada3bb04a008cef4a06bcc7d2676704a16"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end