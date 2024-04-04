class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.3.3.tar.gz"
  sha256 "6005386eb471a0c35b277e82028fef6db777f876b2691ed30bcc41b0f63e3740"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "150d32e4540fb3381805caed873e63e379275f9b09733e6987a726cd524e63de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adcef63d9ce127f8335092eccfe04fbc87507e95aa9aa5a12d9cb921880c882e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55e510f9055666d8e55e015a1b43442a218f1e05635dae5974bbde256f24dd45"
    sha256 cellar: :any_skip_relocation, sonoma:         "7021f16f8af139be38687777a782ca048aa429585915d98fdd320621946f2ef3"
    sha256 cellar: :any_skip_relocation, ventura:        "32f0898cf29f5d86abee904928bd78e02a645c73d81526cf975bc6033f424927"
    sha256 cellar: :any_skip_relocation, monterey:       "9f0f783809b636f78016d9b6c404aecfeb39047823c10120014a0c34d2fc7b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a4f8f79996b0e1fae88c99edec3ef61078add6fcd83cc37aae4f5a09d2e98a6"
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