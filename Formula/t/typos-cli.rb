class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.28.1.tar.gz"
  sha256 "fea58e99f7a53d69d9564a87913a6596d253f454c276c86e5e9b6a52e0eeb43a"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cd6e4af18e3ec40ee5b5ed67dd6ae0d171a00f2deff0d7269916dd4d56f80d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8892530a829edca4c773ffd44390ec63b8af72abd05cac8c540d813d5b9b0572"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5e818dbc7aec4ac19ba863ba248888d6a504057a860b28c8a5a74c737238625"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0a02d109e30ab5a7444c7ec86f48fc977a1a32cb18b6268a02878309eb76163"
    sha256 cellar: :any_skip_relocation, ventura:       "ad68c6d1eb567d6a9958c9e8827250c7a43de015a63f934b49ec29587070672f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aed53c19045a5d5d5008b860d220d9b6d45fd1ecf2facba6cec5a13d960607c4"
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