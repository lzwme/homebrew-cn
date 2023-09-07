class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://ghproxy.com/https://github.com/Workiva/frugal/archive/refs/tags/v3.16.27.tar.gz"
  sha256 "be24241257573dc65605afdb958d4a289864413b12e6970725c495f36d1b0576"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c441f18d6473adba3b1e92adc6f43268dc37ea3a1b21f65a289cecd1b67518fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b1d8ad1aa4da75f4b760cde9726ef42b5a32185e6ddc5d9be2a489904611481"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9368e45a22f06ee012608acd49dd20c764e31c72c1daa1300707d857c7e99956"
    sha256 cellar: :any_skip_relocation, ventura:        "fa53075bdf31d0458d1bbdda8adb6c6c0d15b86e797499021a29d058b4374231"
    sha256 cellar: :any_skip_relocation, monterey:       "0519d48f5185b60d34770ba25fa942c68a4df3d45dcf459acb62673e33986551"
    sha256 cellar: :any_skip_relocation, big_sur:        "77ec9942fc9b3b050bdcdf3f98c4d7f92297d2cc94e5719dc6745274062f0809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "780f354304164fee0bc00fb7d6cf0f4e9c0ad998246055018701c3f24ec608f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end