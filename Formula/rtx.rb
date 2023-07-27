class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "b61d1a599e59cd04c13d9534c861324b4ce85a1e5183200bd9008b157be27d65"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44b6c124470384b3c4af1ae3a5dffdc20db34a7ccb0ba9da53447a6efd9bd003"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "010fe38c442a5e21c4b8e84ab62dffe9a4e8c67bfc5e1d51e8c8c0a1f3d7c9f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33b447ab5eaecab5c1649df83cdcb6450ba496048c57657df02970331eb0e333"
    sha256 cellar: :any_skip_relocation, ventura:        "a3461c6e9881358128aba02e521d2fe58e7d948324ec5b4560da9a34094ff761"
    sha256 cellar: :any_skip_relocation, monterey:       "bfbda7b23ee91e05ea4ef3b8acc5968e1f472c2ad9e52f1961ebf69f38691cd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9d0ae15b4c9445c6e010a516aa750f40c2366d59d42c3aec89c59e764b329ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d0548d4f00043e3f9074d6f1ef1510c9f2d56fc346967751e8b0684de1ec79"
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