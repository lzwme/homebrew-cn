class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.20.10.tar.gz"
  sha256 "d9fa88f6e74c3801e72cd0e77401d49973bfdf63dfd17902b3fc5120a0a32af8"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec520ea1b1511240a5f62c108ec33618f56fda3171690b612bb9a97f301eac9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "237b942b1dcf8c29f8cfdef105cc70845227c13508ca08cf197452cc8d5ecf9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12013e326ee3d6d055b951743f054c5830af2f74a41232413fb076016020c70a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ec1259c8c3ad5ab29e18d5dfd6b6a17f90b8691bff14f54244f507fb42b0bf4"
    sha256 cellar: :any_skip_relocation, ventura:        "4f6dc4093d01376381716daa4cc75b545a88f1f8fd92e1d305695e1bbc668ea8"
    sha256 cellar: :any_skip_relocation, monterey:       "682238b4b7e4b0e8c9a5394105cf62b2fc0ce44491f4d10d96d75131eea8a873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "613edc0570b464a138d43620befe056989bca6d83afa033800fb8145f05fb4bf"
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