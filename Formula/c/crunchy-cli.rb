class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.6.7.tar.gz"
  sha256 "743c2d5dd603ee14e63af8ac8cbae1cd80acce6bfa87934571e379bcf01949e6"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eff25dab580ce0fab83a7bd145c4135f60bc7a33ea7dc2beff2ff1dcec221238"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab6f53c667b82494a40e421fcc8f708e2443e19903991e2352acc4412911ae4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26658e2958c936ebb325748349492bab65d7c85c3d7e8b26f6e954661dbfb299"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcd5a79d345f349e356ce9dcb3946a9bc3285e05fd1dac90d10480639afa7e05"
    sha256 cellar: :any_skip_relocation, ventura:        "e22153bc82c7d620d0b974c7028a3600730146ec5cd001dbca81267a38ad7199"
    sha256 cellar: :any_skip_relocation, monterey:       "2da874bb0fa697266a2575eae4f75602575f9e3a6137719dd535ec5fd72c28a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bfb8108c92d7926879b6c3067632692db81b020f9d52166f17e788a6b64b391"
  end

  deprecate! date: "2024-07-16", because: :repo_archived

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