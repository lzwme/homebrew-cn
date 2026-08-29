class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "00bb5b96e4c7f8a652ab26f2bec3f9babf40efd3260ed3cebac6737e5de5171c"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aac1b72aeae7eef46cc25f7bb4dc9f70392a402e312edc11ee9fa9c6774901b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5390ef5f70e437c6cd59596884920961dec1b855d4e4f0935706c5385199aee5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7fbe7b672c2568848a499694a10776eb6da4488da9e962f606ac0590f919a2b"
    sha256 cellar: :any,                 arm64_linux:   "088b172a1adf9705f5d06f8c4c9b223ca6a1e92f12133f1c81814b368d525321"
    sha256 cellar: :any,                 x86_64_linux:  "3e7ae51e631101373cbb59f7b6bdcec6984159bc1896a3c860a0186d2035be9e"
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