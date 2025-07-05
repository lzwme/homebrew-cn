class Mlc < Formula
  desc "Check for broken links in markup files"
  homepage "https://github.com/becheran/mlc"
  url "https://ghfast.top/https://github.com/becheran/mlc/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "18d22c96cf2fccd6937268db141c74f24fa3113d21ac55452d8a7eb05150b489"
  license "MIT"
  head "https://github.com/becheran/mlc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50d59b381fee447f206cf88af1af1b2650c8d88ba52022dd9d71d22e283291cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93503ee4e365b6498cdd7db8721108745d2fab206548ffbfb3b30b54c2377fff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50e2b98f6c763773b63c2a7119d765b7b19ef833f0958fe2d12e5a871f56c725"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c6ae6865883e5d173b404d6709033f2bae396625ba74bdc135a24c2a1471787"
    sha256 cellar: :any_skip_relocation, ventura:       "3e1b6206db3d2dd7dda58a2e11ec048531993d6b7a6da8926e9cc4f590eb41b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe1c4efd926fcf95d1960858c7df6d779cdf220534e49159286a1b818b5b381a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c45544bb747af27fe6cf7dc4083e5c5d5be0beb94a989f825ca0de2e21956d86"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Explicitly set linker to avoid Cargo defaulting to
    # incorrect or outdated linker (e.g. x86_64-apple-darwin14-clang)
    ENV["RUSTFLAGS"] = "-C linker=#{ENV.cc}"

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mlc --version")

    (testpath/"test.md").write <<~MARKDOWN
      This link is valid: [test2](test2.md)
    MARKDOWN

    (testpath/"test2.md").write <<~MARKDOWN
      This link is not valid: [test3](test3.md)
    MARKDOWN

    assert_match(/OK\s+1\nSkipped\s+0\nWarnings\s+0\nErrors\s+0/, shell_output("#{bin}/mlc #{testpath}/test.md"))
    assert_match(/OK\s+1\nSkipped\s+0\nWarnings\s+0\nErrors\s+1/, shell_output("#{bin}/mlc .", 1))
  end
end