class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "a615c8dce241c4117a23c81fac553ca6abae7d0f3906c1b45ab7ee804c3cd6cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6156115cd48900354aacf71579057bdd4f6ec5959bb1c0de57385eee4e5f7020"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0a5532e0b6dbceb7177cc463397630c35e75119534c8935496c39b2d064ee37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddf9f5c8b0086eaec9f02d913bf4f3fc4a2810dfdba2f4cd7bb9c489a6da2a14"
    sha256 cellar: :any_skip_relocation, sonoma:        "687d8f7df525f6425385cd99d39c66e35386b5312d9bff15bff32349a76f30ba"
    sha256 cellar: :any_skip_relocation, ventura:       "a9081754094f8ef2a2e0d97cd5792af7ce36a944493a4f8cc9e84d3f8d266137"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "951fa85aa9fb8f5f2e82bde21eaa3ec33d138a3fcb7e8b3e0eb134b3f598ec3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26a2dc4508bfe211f7074679621b7fe93eb03aabe645dc98b144a8e24a2837c2"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end