class Orbicfg < Formula
  desc "Tool to decrypt Netgear Orbi configuration files"
  homepage "https://github.com/Fysac/orbicfg/tree/go-rewrite"
  url "https://ghproxy.com/https://github.com/Fysac/orbicfg/archive/7d264db962a70e8f3ddfdfe50189ac5e2a1c4743.tar.gz"
  version "2023-02-03"
  sha256 "2f6ce05a8f1166e7fa38b436175f29c81b7f075ef884562b73c6dcc804dd8af0"
  license ""
  head "https://github.com/Fysac/orbicfg.git", branch: "go-rewrite"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/orbicfg"
  end
end