class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.27.12.tar.gz"
  sha256 "ef47a76bfceda14e04b36abedbbc9618cdb6abe8b6564da14251f9f9ede80fb8"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba02cbc980424f90b2af2f4038cf0d5823e77fc7f0c87ab0af7fa6ff27f0071d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edc3c61ebc54de93a23546399aa0fd0b5c32774a6e1ae2b61f1e8f834c0e9fec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f5ad0ee968719d74cc838fcbda05cba9a14407acb14b19f4571000ffd6ccd8e"
    sha256 cellar: :any_skip_relocation, ventura:        "13526e62a3bd41e254b59e8f237fad9325fe796c157978f35bff5bdfad6191da"
    sha256 cellar: :any_skip_relocation, monterey:       "82191a618994170d743ea470260db4f6b4f0830105634116f2af9285ad4c77f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fb18ed3705291b24be3b4f8d3a9f090f683158e860d7e815c0c7431c87dfb67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6db180af74bccc054e0c30db53acfbd0931c1e8ead35133e776e2536d161c612"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end