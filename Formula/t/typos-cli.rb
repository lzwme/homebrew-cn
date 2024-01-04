class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.17.0.tar.gz"
  sha256 "3a1fb3ba5c4c5669cdd6b43c506a388888f9bb454212a5adad8ab405e93f226d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11f20537c8e08fb1ef6aa52d15cda2cc73fc60d97fd070a29af0101b44b4898c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e4d35c2029357bda04fb515b7de08a791a2ad7c382d114aed0579e596402c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5798f15b12f6cddd01b19ddf795ca9e7ebcb2ffcc8a46f19b1ac376f7303c653"
    sha256 cellar: :any_skip_relocation, sonoma:         "9180f2feba6fea59e259f10242b8f62f1f5c6ec1b5abaaec662c9bb726ff832e"
    sha256 cellar: :any_skip_relocation, ventura:        "f07e483ac906fb6dada230d12f66ab90e572b8e7d7dd840830b55788f0ee5583"
    sha256 cellar: :any_skip_relocation, monterey:       "f85bf15f69b2f6f33aae67841de50f0894fb1c3835a702fddace5007a3d0a112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "201567f2b8d40a64c8477d73e816ae5c854b1623a2f49a285e19b79aab882570"
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