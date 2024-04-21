class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.5.0.tar.gz"
  sha256 "0f6b278268269a4ae5e6bef4bd637f8ecc3632723271a285d9c62e2147a0b7e7"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12f5278f69e539ddedef3b14598e4137f6c3866f2589bcf5a11570653703d5ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6096f533cb5382b1a917ef4f0f2bc256d81f9c7c0a1167e7c90d034cf65b2cf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8aaed20418c03596ffad2a708deb947fa9f90e49323d242d169c7be0b2c72b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f371a23b25c432fa98d62f20adb186484a25e536629f43b6d7edbee11d7f695"
    sha256 cellar: :any_skip_relocation, ventura:        "34d9d8b12cfb5c333eb8aeaa74becc42f28c165092bf6760740cf77f0353298b"
    sha256 cellar: :any_skip_relocation, monterey:       "25655c57c1b5a07da9a05be8d665deb3b9db823bf98c7bbbd18d4693681dcf6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a0f36a67a90cf711cd7a5c154c0291b0be006337ec4955582febd7735e11765"
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