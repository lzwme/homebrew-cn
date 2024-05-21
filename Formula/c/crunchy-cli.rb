class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.6.3.tar.gz"
  sha256 "17942454462c4d6eb69b00d9e69ee01df3f163104a22269fd15d01225b324716"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09745465331e1784d4cd7f1ddbfddcf4bf2499d45edae89e302653afd92731d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8abde557e6a1b92c1f5a533fb3b636704c3609a37225b7ea2a0b52e4c947596a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecbf8c5782f9d29503323a861c8f89443fdb8c0569645f63bdea8c4311186000"
    sha256 cellar: :any_skip_relocation, sonoma:         "070e7f8b8cc9e3f863a3b73aa86ccdd48a201317f9b616d5ac43e6bd1918509a"
    sha256 cellar: :any_skip_relocation, ventura:        "79cb30bc139ff507abd8d5dae756b9675dc821c433ad80d37e8a37e69c8b369c"
    sha256 cellar: :any_skip_relocation, monterey:       "89ee72421034a7b0aa6460a296235006d3be823ddef37c6cf31591d496d7633f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff1e7f565606a11faac5af054ef4077cbf59631c5dca1d52469d0fd55addd7a5"
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