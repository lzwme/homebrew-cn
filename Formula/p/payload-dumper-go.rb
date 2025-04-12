class PayloadDumperGo < Formula
  desc "Android OTA payload dumper written in Go"
  homepage "https:github.comssutpayload-dumper-go"
  url "https:github.comssutpayload-dumper-goarchiverefstags1.3.0.tar.gz"
  sha256 "d7ba33a80c539674c0b63443b8c6dd9c2040ec996323f38ffe72e024d302eb2d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "298d73ff6bdcbe98ec51938eda5d6df35f4a67eb48538ab3d0a8d5e7f5ededea"
    sha256 cellar: :any,                 arm64_sonoma:  "a6be6a71b98e5cbccf85f5fd5ddf49ec28792545ebdff739a275c6c32a7ee34c"
    sha256 cellar: :any,                 arm64_ventura: "adc25ef9cc348ff0f4e72aee84a8d73d4eecc77ec8228b8ef451a1ba52947a3c"
    sha256 cellar: :any,                 sonoma:        "43c27225c84681b696cc133dd3027dcdb8a99434eaaae57adf9d24b10a761b09"
    sha256 cellar: :any,                 ventura:       "9a7fe312cc474f61625712007bb096a34ec93fb165afe887cd2786c7fbd71ee1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f89b0e2f2ffb8fc2ec9c58f91aa50ea18243bbb2c15c4682df72931fda29c21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dec1676646bcf9b015900ac1d9c7f5f1912671bdd034e511235b38c95e63cc3c"
  end

  depends_on "go" => :build
  depends_on "xz"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "base64"

    (testpath"payload.bin").write ::Base64.decode64 <<~EOS
      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
    EOS
    assert_match(Payload Version: 2, shell_output("#{bin}payload-dumper-go -l payload.bin"))
  end
end