class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https:hurl.dev"
  license "Apache-2.0"
  head "https:github.comOrange-OpenSourcehurl.git", branch: "master"

  stable do
    url "https:github.comOrange-OpenSourcehurlarchiverefstags4.3.0.tar.gz"
    sha256 "499f2430ee6b73b0414ab8aa3c9298be8276e7b404b13c76e4c02a86eb1db9cd"

    # rust 1.79.0 build patch, upstream pr ref, https:github.comOrange-OpenSourcehurlpull2923
    patch do
      url "https:github.comOrange-OpenSourcehurlcommitd51c275fc63d1ee5bbdc6fc70279ec8dae86a9c1.patch?full_index=1"
      sha256 "02d9ae4f8282c4b73f3f5741deaaafa53d6f289120870b0b95bd7ecc1e0166a3"
    end
  end

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ee7cf447f030597d82e8a83ee37107b818598dac1ea3af04f6f80ee4120012f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dff40910852829139374fb29e7ecc79d9020552c72518ce3b25b5bec372a5858"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "990b4814e7ff7969f96a08b7718868c5ec687f5ac348aa376da58e7cec5fe01f"
    sha256 cellar: :any_skip_relocation, sonoma:         "539dc8fa94b7bc1e919b5a26851ba01ccb6c2330678b1e0870ddd90097893b01"
    sha256 cellar: :any_skip_relocation, ventura:        "917abbae8169238b16283dca3607fa475dfdda7acc1083e9c2fd1db708262667"
    sha256 cellar: :any_skip_relocation, monterey:       "73e46d317b0d87acec0bb6e97e56bd7ed4b457cc71e57c06506db73ffe064b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d02a94cbdaa80a5f743df78ae6c9b343711467af394d1251afb4dd13c814d17"
  end

  depends_on "pkg-config" => :build
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
    filename = (testpath"test.hurl")
    filename.write "GET https:hurl.dev"
    system bin"hurl", "--color", filename
    system "#{bin}hurlfmt", "--color", filename
  end
end