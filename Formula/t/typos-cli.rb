class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.20.4.tar.gz"
  sha256 "8fca708f75bdfd3f037b5e8d8cf4a532922d96de582c4458e592c76ce31ed831"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa40be4e73354ff721f2e1c708f859b0aaca9ce21e901d9150fdf043cc298428"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83f0f854d0d7bc127d744681fb981d592825695ff1640ea2951fd7c74f38bdbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "334737bfd6513708b90a668a857e2d040026d6a923a929212336cf82d1ceda47"
    sha256 cellar: :any_skip_relocation, sonoma:         "e38e29246d0487700a438e6b283231e051d542ad5458fb04fcbf0f46024da21e"
    sha256 cellar: :any_skip_relocation, ventura:        "6f13dd726eab0d9a9838cdb00434deb8d4e0c83bbc22b883cd2bbf5afe52bd52"
    sha256 cellar: :any_skip_relocation, monterey:       "de063e3fd35f4f2276bdc69679b3913cd6f8d4608840f31e836ff19631321cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0da10d686ea2a1d8f2f9530111d1f896e8c5b0a89ef1cd350f7fd3255b7ee2bc"
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