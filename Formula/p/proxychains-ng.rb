class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https:github.comrofl0rproxychains-ng"
  url "https:github.comrofl0rproxychains-ngarchiverefstagsv4.16.tar.gz"
  sha256 "5f66908044cc0c504f4a7e618ae390c9a78d108d3f713d7839e440693f43b5e7"
  license "GPL-2.0-or-later"
  head "https:github.comrofl0rproxychains-ng.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "0ca6d6c42b3402ea056555c47cf921ad0c6eff7b471a27c68321d914b5875f33"
    sha256 arm64_ventura:  "1bc1b52df2f57921158ffed11abe9f759aaaca442f69839f035c4a6fbbb987f2"
    sha256 arm64_monterey: "ce214ff6acd1265dc03907d4415c1b7d883862d56e046f305fb7ad1a23295840"
    sha256 arm64_big_sur:  "4a5d12dcf616731f16127b8c2a0f77adccaa813a74e9952bf7de504f4f6818c2"
    sha256 sonoma:         "0fbf10de58d8e765caa88b240cb899530ecb3792bddac5f30900e7e39163e2cb"
    sha256 ventura:        "0bdd42d9b1e1a9edb51c9e41cfca87db863d8632e1125f9acd5be9e83a357995"
    sha256 monterey:       "68cdf4b1a018cc0a94513227ff073dfa430658f330dce45dcc041e001639e8f1"
    sha256 big_sur:        "e1c1f4075d1b7bc8e4aa3053ff0fddb53f0813080785583fff7bf5037c8fa835"
    sha256 catalina:       "b85d3715f51bd972366c176cc9a75c8b1303812fde82c879e12b17657db08789"
    sha256 x86_64_linux:   "b88fdbfcdada3fca4d4e8e8195d848aad96fe2b242888f6466df7b5535b598a6"
  end

  def install
    system ".configure", *std_configure_args, "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}proxychains4 test 2>&1", 1)
  end
end