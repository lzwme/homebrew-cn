class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.32.0.tar.gz"
  sha256 "dbd76ed0b908b9f19c7dff34ba0c71ce1da731a065590f9992a7a08390373bac"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e06bea6d6e2bb223aa3f7acf78f0809d03359a30ad1fbf0bfbe96adc64e8cf8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f954b34e2072151ba69d7edb30016100a04ee7ba5f553f59650ab9334ba7b689"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e785db16d720003728c3eaaec9b2b29e93ba7fb512067716b11c0fa36af5e3aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bb2a419eb05aaad9c1a6cedbbd8a2ef97419c1560d24fc4c74b1c4bd844d5b9"
    sha256 cellar: :any_skip_relocation, ventura:        "1167af59588887deef6753882662a090cc9413624cd1fa23f6f26405e6d18cb8"
    sha256 cellar: :any_skip_relocation, monterey:       "1de203eb9527b2e5cbc4fa05918368b632088cd0eee816bb932216bb882dd0df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e6fb93de3180bf811302236adeedd7019fbce89dc73fb86ca6576d88b62665a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end