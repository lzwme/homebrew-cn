class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.2.4.tar.gz"
  sha256 "0ffe6f2b2dc3fa8cefe7cf019043367d7c625a8a87d15a29d599662614bc586c"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b29cbd491811ba98d89936c6ad7e4c6df44cea8883641399f62124b39075731"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bee6ddfbd1d2c308ab61b29ee2492a936646ceb75b601d57e27e398d49c6482e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45bc183f1afb27a1dd907c1e12b56fa3193f4bcd2df9885f591b8122cec2e6a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "62397de39dc7afc38f7e622d068e0aca8cbc9349c874741d6427ce6cd71b6498"
    sha256 cellar: :any_skip_relocation, ventura:        "ffb7f1ca68d67b8812b000556f49437a2cbe7dc204329973eb7f0bf186c6e2fa"
    sha256 cellar: :any_skip_relocation, monterey:       "578abecbfbffb1e34e5120bca06059d7136f5256bc36739b0f926bc0a24b9b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e97eaadad8c4b45d6da72175e9db245a89bd33f6ffc96d814c555082109306"
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