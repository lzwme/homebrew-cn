class Tuc < Formula
  desc "Text manipulation and cutting tool"
  homepage "https://github.com/riquito/tuc"
  url "https://ghproxy.com/https://github.com/riquito/tuc/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d5dc8f9a7739450707e3f630038fa83d97c080c7397e7afbcec44682646c497e"
  license "GPL-3.0-or-later"
  head "https://github.com/riquito/tuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "199b4499932453f78a9815b2dec30d27c87bd969ed8a1252781466ca4edb8497"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b9c83897196b9a7ed5760db619dfe2c193184400ef45765589336cd25763762"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ea9ff126127c2c2e5220444144c4e7d84b2462b583e31c72cec3dff5fe4ab43"
    sha256 cellar: :any_skip_relocation, sonoma:         "55fb6237c0701cd0395fe0102114cdfd7f2a4d73e26e84023d63ee0273e2b233"
    sha256 cellar: :any_skip_relocation, ventura:        "6b6586c6bd773195c60bd686bb85af35f6fbc21e5acdc769c3e5f46d77268d1e"
    sha256 cellar: :any_skip_relocation, monterey:       "348692e46b6e85cf82330bfb4384244b45fd4fa2ca86ec83a3b18e635e55321c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51480c02f0bbcf0216954cf3c1bf332d5ac7da27edceee9bc5d5275e7ff8288a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "regex", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/tuc -e '[, ]+' -f 1,3", "a,b, c")
    assert_equal "ac\n", output
  end
end