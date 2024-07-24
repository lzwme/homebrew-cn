class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.23.3.tar.gz"
  sha256 "091526873a992de80a694fbf1939982250b1b75ca4b86ac8808242c81180230b"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00737530dcb6660da7b1f29a15aa72bfb7da26c114aa8e81c0889317953eac12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83e9af7cc1e0453c9ec6913189ce0049bd843c28006af6a4a548703157cded74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c162a18c35b599e0db2357b864aa6b9d57740af7d682fe4b910883e493cd0922"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fbb1f8c581b03124db4bec4bccc5f1a1530fa7b149513ee5f9c47a7d72d0346"
    sha256 cellar: :any_skip_relocation, ventura:        "8c83792da9f41791f6e0ef00d60bdd092a09fe17abb32d0ee71557f133ee1add"
    sha256 cellar: :any_skip_relocation, monterey:       "ede753f6a13ce162f611d4685611a68630e57edb91dfeefacb26af64fada62c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de9e143d644086834d0e2da7d0721d272b8ced59c2ddb0131a553f035355c74f"
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