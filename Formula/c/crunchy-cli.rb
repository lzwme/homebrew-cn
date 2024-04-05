class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.3.4.tar.gz"
  sha256 "6d4799d5e46543cc5993ab7d410b46837a8d426249cc73c982ec758fc9a12278"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2116ef2524fddf4400e00ff08e84a694f538deb4a70abb95608ea5b77fb20116"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6768315f4edb76c0e71fc9538c3fe8d7097c4ad17c68022fd776c7f407d1d00d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef6fb8648152ef801521a7787ce4f17ba926175e5920032ce6c847114c9fd026"
    sha256 cellar: :any_skip_relocation, sonoma:         "919a11204cc622cf4ae54759aa4dd010754b0fd91f667ad3c8faeb607f08464b"
    sha256 cellar: :any_skip_relocation, ventura:        "fb48f3ea0fd9aec50a5557c0dfcba3336ef4da5d39b1b25e620ac82478d6d9c1"
    sha256 cellar: :any_skip_relocation, monterey:       "a451cbb6d88faaae98adfacb170d5a40c34df8ea00fd5b6b7b8e7e1ab94f5931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a463dcb47b8a078d5b67a51d1134ace4bb0d7e00cd37642417636c2bd020d1"
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