class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.5.1.tar.gz"
  sha256 "480034f0f50c89ec125d4a1d3bd2c63a011ee92b6d7709868b4007e626ccd307"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7584f348ef3170b1a9ec140afc12c3c7c4a21b0171e048097d25d39fb1ff87a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "455f861faf231d922845a330abb2e4577046d33959484bed5dc763f3cad0c7fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "335cafff4e8b5aec78050de394efba6d4d0bba278709a22cbbe77f2e95fdf152"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bb9fadf7b737bc8be7d38ff13ca22a8830cce1c72cc12db28af3b6c10da967b"
    sha256 cellar: :any_skip_relocation, ventura:        "40b42b02c79277b51c99bc42228a9a2b98cb87ddf8d1bce15a5f133f7b83a57c"
    sha256 cellar: :any_skip_relocation, monterey:       "9ce8a7fa1c376b406c50eed15d052c0ca45ab8413f2fb33a3dad34cc09b4e021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48d468f088a218de587286a156980ae723491798779490f78f66b73a91969933"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--no-default-features", "--features", "openssl-tls", *std_cargo_args
    man1.install Dir["targetreleasemanpages*"]
    bash_completion.install "targetreleasecompletionscrunchy-cli.bash"
    fish_completion.install "targetreleasecompletionscrunchy-cli.fish"
    zsh_completion.install "targetreleasecompletions_crunchy-cli"
  end

  test do
    agent = "Mozilla5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko20100101 Firefox119.0"
    opts = "--anonymous --user-agent '#{agent}'"
    output = shell_output("#{bin}crunchy-cli #{opts} login 2>&1", 1).strip
    assert_match((An error occurred: Anonymous login cannot be saved|Triggered Cloudflare bot protection), output)
  end
end