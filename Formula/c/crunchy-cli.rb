class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.2.3.tar.gz"
  sha256 "44d7475616d215ede21e06303c35f9a003d74e0ec4d0bb8d6a49c291c2794bc4"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6ef80b93a0213a6a1478c830c78ae2b06fb424878f08370a3e0815937d45f31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab0ebdf27d04403fc8401e0e4ccfd7a5f4659da13ce46b68795d7bd0a145d58c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad11f9cdfba99dab1c2917b410fcbc3add8bfc0c4942cd5ed605b562396216b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef878c2e786255443a0b4fd73cae32ac94e60744e464a589bea4cbf8908838dc"
    sha256 cellar: :any_skip_relocation, ventura:        "cff5fc334d02be7ec7ce69954e285d042f6c52e91f9859b796ede4361a97e5fe"
    sha256 cellar: :any_skip_relocation, monterey:       "9dca18a4c8a3968c43e81e6898f24e8b078a6f91dab74be2349a028999641436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7132d8e352f26b7daab280d3fdf1eb12b4e19c79ae182a87c8bb88f7fc7406c1"
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