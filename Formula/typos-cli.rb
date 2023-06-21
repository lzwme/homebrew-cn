class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "b41a108517cdb639377c889a4f234066bccd51a19bdbb0c76a320302b950b28e"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e9ee6d2e491545609cc6d5782f5a82f5c2fcb13f50085fafd1f0018dc0a7c3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a69e22787436421e314b5b79e224547cac2ef55ae43219a7b81f5dda42b914e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "948b57b64049d74bf36b2d54d735d267342071e8b6c7ecb9e1bf9d725266b3ff"
    sha256 cellar: :any_skip_relocation, ventura:        "0c728bf5e074ef101310c7857e28c437f3025f5508da0af40066cfb575ad9d71"
    sha256 cellar: :any_skip_relocation, monterey:       "c593c76f6176adca27a55cb9e9d134a9a7540bb783855b2fd5c22539cf32cbce"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d22472520dedfaf67a5fa4ffb1db5a6fb29c3ed865372b412d171fc0b1fb502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a951b3a3f5a66467b573345498713c42331bb7cf09fe694f8f3b116236ca3234"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end