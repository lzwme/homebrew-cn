class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.23.4.tar.gz"
  sha256 "90a255bc3c127dd5f3c9a5d24bb37b39d6763b86622a9a93ecbbb78f3a74e303"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a74a2f5158870a1657f0c11c640204ffbf5ff52e1003039a493313d03019acec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6061564848aaa3a6226e39784521ec884236a338723964b45652571761ac1976"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c168b69ac78fcd0bf177c70545956bc9e431e4c983876c0dd661c860cf73eba"
    sha256 cellar: :any_skip_relocation, sonoma:         "e21084e8b194f14742337a8f7dc14cee42091108e56528a4a00cfc5c46737127"
    sha256 cellar: :any_skip_relocation, ventura:        "985bae16eb477f111e9422841d1d14d9373ed2c98bcdaef4cbc019f0f367335d"
    sha256 cellar: :any_skip_relocation, monterey:       "680926a6fd6e750547e03679f0a6aed4fcf25126183e994c18412f9e75fcb2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac60827fdd12c31a8a299565e481f1c17d6a94164282db41d374f54eee0d560b"
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