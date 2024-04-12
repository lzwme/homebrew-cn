class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.4.2.tar.gz"
  sha256 "206ddedcca0ad2c11b832ce0718ec8a52ea301989ec3a162ae498117ee139a48"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abcdc4f735eb75f969b70156072a86b0bf207f93ad402b8c20b0cca6dccc50ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "528663779052f4eaa396a230575219b2cc66c04321a4840898048a2545a2f504"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f85957704a27a411391376665256302d5673aa8b8d88e7e9dedd5248872b5abe"
    sha256 cellar: :any_skip_relocation, sonoma:         "17c36d7ed150251dec6ff35c381c6f58c4cb1e237ca3057f2dbbf804aa98aa2f"
    sha256 cellar: :any_skip_relocation, ventura:        "e0a6a82be7bf15b44dac2f12339e7b2a6f900677202a972fd66156a606cca733"
    sha256 cellar: :any_skip_relocation, monterey:       "5cbd16e4bc163ca842012763d1d9889cece98a4febc1b4f24eda462997e4e46d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c1293aa283dad765c80771d3e272dae4a450eafff25d55a7d383594c946a390"
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