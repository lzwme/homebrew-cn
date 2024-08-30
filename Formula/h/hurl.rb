class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https:hurl.dev"
  url "https:github.comOrange-OpenSourcehurlarchiverefstags5.0.0.tar.gz"
  sha256 "6d19d1b0ec7de44f33206b0dfd6c1c76ae61741fe9fcddd979359e061ed6f0e5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25088d0ea6e8f3e2650d12dbbde26b68ebf48039c8d6824c570671acc92b98d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e72b7c1580fe6fdc4ffcef4001ff50a7fef4c0aa691786aa63ce63d6f3df0757"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "936f829627e444b6a9ad547303eafdbefb6bad35f89166bdb225b556f8b0549a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6aece89409d1cabf15586f107de460163e4d6b8e165e68169b1c92243985cca"
    sha256 cellar: :any_skip_relocation, ventura:        "0c035d3809275897016712e43ee884f67af819fb215753a044a40f20fbed6dd9"
    sha256 cellar: :any_skip_relocation, monterey:       "b69865d6bf403be8f89b68251f3cafadaffad1bd4350f42940bb29996c0f021b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf7daee2a19c0fdedb8f0d90fbd3fa191980c0d6d8d5e0818ebdf7af59549871"
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
    test_file = testpath"test.hurl"
    test_file.write "GET https:hurl.dev"

    system bin"hurl", "--color", test_file
    system bin"hurlfmt", "--color", test_file
  end
end