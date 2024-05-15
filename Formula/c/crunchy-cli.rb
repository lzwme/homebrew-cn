class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.6.2.tar.gz"
  sha256 "1566721f8eeb25e5027bff8559eb45c3036adb99cb440bdc8ef67830ace528d7"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f36c2442f6975c8192a77b08e71053343bb50d3402938e02cebf2177b27fd3fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e45ddb13c5925c2747af10f18fefced282fe97f35961adcc90c708efc9e9cbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ff18df28eed04de8fd2b316f6483b1c493c41bea26823850a5fef2af40ee4a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ce740a7059fa77d2f4c56c5ea5b3ee5102bf00487560d185d44765073edaefb"
    sha256 cellar: :any_skip_relocation, ventura:        "39ef96a78e773329adf11d16a7e655d834d04d730c49f16d4acdc2441bbd22f4"
    sha256 cellar: :any_skip_relocation, monterey:       "887b54f6c9bd6f38aacadf8f9f2a9b8dad393effd01a7a73dd29b6fa5144cf8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5144991b579e65c9ed46e24726b4c37a495a2790271d3eb1ed0e2ccb0c416dc8"
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