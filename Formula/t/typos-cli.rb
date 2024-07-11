class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.23.2.tar.gz"
  sha256 "6c40cedf804b017535d2f27191d8e8f768169141dc262dbe2ac91212100a8f03"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caa4e617079fb7d48c54797fe983396452080ae6cfb1890169f8d9215b0ebe70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "733803378cd1ee70f56d31eb48eb2e3eaaa9a77784910452f0eec2368fa7eff7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dd292b3161fca468f44b52f96249d947690d14efea60c9596b76fb3ed2d9a98"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cc24888b1ac7d7ddb4e51ac439125b012448d83ee5e4cf3b9cf15d4dd1baece"
    sha256 cellar: :any_skip_relocation, ventura:        "c2bb43e69b3f1d2c64ea6c27510e0e610a259e0497654d027c0db409e7870f0c"
    sha256 cellar: :any_skip_relocation, monterey:       "fbdde2b62b65adbaf3312cae324c6e1c255109a9c796b182572efc052757924e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2765aaa1dcc188efb22b532226763ff2b33c86fd8792f70191f481dbe1052432"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end