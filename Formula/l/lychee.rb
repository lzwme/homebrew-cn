class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https:github.comlycheeverselychee"
  url "https:github.comlycheeverselycheearchiverefstagsv0.15.0.tar.gz"
  sha256 "3658a4420a7176231a204e35e11c324a2281113c8ed7f11cc61300974ea46096"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comlycheeverselychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e1360e5fd6449c40ff5ca2aa4e9f5f6c6e955dcc71df293c8279065deeaddc19"
    sha256 cellar: :any,                 arm64_ventura:  "605ad51f3ece66bce5c9db42dbe5b1e99f6776dd1a341f8568af340a4a6995ec"
    sha256 cellar: :any,                 arm64_monterey: "c093662f60236054606bc12fa81d32f63801cec2ad141705d80f09334fef41c6"
    sha256 cellar: :any,                 sonoma:         "bb6ec8e456bdb73dd22761c5e92e8cfc1f0a48800218ab4eee0fa1e65392a8ca"
    sha256 cellar: :any,                 ventura:        "13e0e2fda04481094af049831507697a40e648c8230178ace31724eea7003c7e"
    sha256 cellar: :any,                 monterey:       "27c06b295b52e257ec3bc91ee40bfd8abd2a4794a9e70c5ed9c4415680579478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28bd2b37a948cb01caa0ad3ce244bf610f8ae9bbd1e09744d0700666ca72acab"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath"test.md").write "[This](https:example.com) is an example.\n"
    output = shell_output(bin"lychee #{testpath}test.md")
    assert_match "✅ 0 OK 🚫 0 Errors 💤 1 Excluded", output
  end
end