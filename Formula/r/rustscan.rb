class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https:github.comrustscanrustscan"
  url "https:github.comRustScanRustScanarchiverefstags2.4.1.tar.gz"
  sha256 "fa99c18a12d4c0939ab69ddb84ef7b85a1ea01d8fc86df227449d89473531765"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50ebbe3662730650662c6f4438c06b70c8bf4c635975ecf3bcf9e081a7862af4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "374f2c989048d26672eb6316f1808fa77a10dfdf11bc9cc84e34a3c790b70b19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad0ca15324e8701793117ae68b6846a0b9551acacece068a1525c4ff997112ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "86a8d2a183f5bec85dc8c40acb58fc9931bb4fcf9e63d3f7fc271d490e5a7f34"
    sha256 cellar: :any_skip_relocation, ventura:       "e2e7f59265f5f1acfbdd4dceea11a4b13cd01fec43ede709efe986640674436a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "045f1455224bee1648c5024d83de72ca209ef19e4784adb2bd5d479bef875bf0"
  end

  depends_on "rust" => :build
  depends_on "nmap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    refute_match("panic", shell_output("#{bin}rustscan --greppable -a 127.0.0.1"))
    refute_match("panic", shell_output("#{bin}rustscan --greppable -a 0.0.0.0"))
  end
end