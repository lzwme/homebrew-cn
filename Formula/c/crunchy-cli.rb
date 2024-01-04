class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.2.1.tar.gz"
  sha256 "c34fa148b114d427fb1d1182a8b7a20fb7188b547135bb8cb0a734b83f823e5f"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fded1637b906c7df1beaa8aaebc47cb81a73e33995f62b3704bead53c77e34bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c25c04c864ade7d61830f8b92d252fbf1e7c0979b1614f9c2208f0339ed602b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0ac4321b223c7224cf5de5e6a4eb05643f5207d09aa8488400bfffe72451cac"
    sha256 cellar: :any_skip_relocation, sonoma:         "aeef204e1dcfa0710f543998d3b0a1870e606485d69749d5b756f7fd3193f675"
    sha256 cellar: :any_skip_relocation, ventura:        "8264f3074cf2972cdeb176df79009c30a57e0884fd28f8a1b2034d474897e0b4"
    sha256 cellar: :any_skip_relocation, monterey:       "6bec0bef3c8ecffb552df11976cee44f349f6c51da92aadece1463b675ccd4af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64be36c027a9832cad7000406b27e01788c395cbf40dc6074b17e3ff486ded0a"
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