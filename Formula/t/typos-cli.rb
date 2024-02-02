class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.18.0.tar.gz"
  sha256 "2ba190f930cf56be0e2f57d678f19d8ab6c7fedd086c6739f9708561c12b9ce8"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "518e9325f5d62e8b62e8d063aa2195534caa47525d1fa40020d7549aae911f38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b34756d56d48ecfc71f93a211bb60f1c0129ee71af23413639eea3c6f4a52a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b46ebd4ac3b8729e39e6d8b5c8bbf73145f528142d1785fd123aac219376a9b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cb0d693fb7e9e92163e066a505a078cb09c594a9f3eefcb1fe13886a11d85e4"
    sha256 cellar: :any_skip_relocation, ventura:        "3564ccadb7ffca36237ad2a79322cc512b1d9e20fb97e499dc04268eee378550"
    sha256 cellar: :any_skip_relocation, monterey:       "8d78bef6e6906de6d80008ef79750feb65f8bd93f392dad2b5d92604187fc075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "267232a6804650d1caff874f9c7184d137d9fd18270e9861f2d4a7926788066a"
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