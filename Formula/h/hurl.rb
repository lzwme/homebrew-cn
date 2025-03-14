class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https:hurl.dev"
  url "https:github.comOrange-OpenSourcehurlarchiverefstags6.1.0.tar.gz"
  sha256 "7ac2cca05a3a22cd92bd10b46c39a4277fd64d10ab989e46a2e8aca112d842f0"
  license "Apache-2.0"
  head "https:github.comOrange-OpenSourcehurl.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9724befbd65ab3cd69ba08f88c06c1e97551ad25acdeeb76d7e91af9f602f68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "680324f2f2726a9c57e8136f88201c82d88ff99179acf8de2f24d2916533c0cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "408048abf2059482fc1da3bd33c221fa070d6f56c2d2531b6eb41f287286272f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1efea483c8eed8f01e054f9b328c5223a167245ca2540ed309d7e959f3d53034"
    sha256 cellar: :any_skip_relocation, ventura:       "b8412c24ff6dd2c065c26bae004f6b6ea1e4dc7cad5510c2622233ababf20ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3742791db0c358f3fee5844972eb3809e03c0f8ed85816b56f2298d7ebf7f9ff"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    # FIXME: This formula uses the `openssl-sys` crate on Linux but does not link with our OpenSSL.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "packageshurl")
    system "cargo", "install", *std_cargo_args(path: "packageshurlfmt")

    man1.install "docsmanualhurl.1"
    man1.install "docsmanualhurlfmt.1"

    bash_completion.install "completionshurl.bash" => "hurl"
    zsh_completion.install "completions_hurl"
    fish_completion.install "completionshurl.fish"
    bash_completion.install "completionshurlfmt.bash" => "hurlfmt"
    zsh_completion.install "completions_hurlfmt"
    fish_completion.install "completionshurlfmt.fish"
  end

  test do
    # Perform a GET request to https:hurl.dev.
    # This requires a network connection, but so does Homebrew in general.
    test_file = testpath"test.hurl"
    test_file.write "GET https:hurl.dev"

    system bin"hurl", "--color", test_file
    system bin"hurlfmt", "--color", test_file
  end
end