class Orbicfg < Formula
  desc "Tool to decrypt Netgear Orbi configuration files"
  homepage "https:github.comFysacorbicfgtreego-rewrite"
  license ""
  head "https:github.comFysacorbicfg.git", branch: "go-rewrite"

  livecheck do
    skip "head-only formula"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"orbicfg"
  end
end