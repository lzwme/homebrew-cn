class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://ghfast.top/https://github.com/Orange-OpenSource/hurl/archive/refs/tags/8.0.0.tar.gz"
  sha256 "d6877cd16109b67a64f8581113c3f061b8759de5577f024b8126cbc5ee393243"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "859f75892784f7b9d7427acbfda6e5a06a3c2ea3e600654a95171baf0844d1bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e23f15c61ca4e97157843d27bd4908ececb0dd4c819f8ebd40aa1d9f264b754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "911448d9f4482516e8410640c241379a6decfca8e3f4e75eb8e950279cc7da34"
    sha256 cellar: :any_skip_relocation, sonoma:        "70dfa20b8bcc5d2112d05ec84754d3a408013db7ebfbbad936bfc0b8837dbe5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa2d18e7dc54282d6236d25d4c9c1c7f805afe9de58d37a75c3c2b53eb6cf18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a0f86a3331185e7a69f8393893e7d4a7ba1c9396833499e8bfb52bfe92f1731"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "llvm" # for libclang

  def install
    # FIXME: This formula uses the `openssl-sys` crate on Linux but does not link with our OpenSSL.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args(path: "packages/hurl")
    system "cargo", "install", *std_cargo_args(path: "packages/hurlfmt")

    man1.install "docs/manual/hurl.1"
    man1.install "docs/manual/hurlfmt.1"

    bash_completion.install "completions/hurl.bash" => "hurl"
    zsh_completion.install "completions/_hurl"
    fish_completion.install "completions/hurl.fish"
    bash_completion.install "completions/hurlfmt.bash" => "hurlfmt"
    zsh_completion.install "completions/_hurlfmt"
    fish_completion.install "completions/hurlfmt.fish"
  end

  test do
    # Perform a GET request to https://hurl.dev.
    # This requires a network connection, but so does Homebrew in general.
    test_file = testpath/"test.hurl"
    test_file.write "GET https://hurl.dev"

    system bin/"hurl", "--color", test_file
    system bin/"hurlfmt", "--color", test_file
  end
end