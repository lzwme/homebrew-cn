class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.6.0.tar.gz"
  sha256 "e82be1d2564dec0e4543b51346120b971260071f7f65726a0ece4e700511f174"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a83acca5d2dd0aaf4093ddad0ec60cb634422ac2155aa1610b96c1f2d2b99969"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d2a74405c0ab6a0730a99c7c11ed62f8a531f10b1e43fb37d9b3d362cf1697c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3a888446fd7d75fe6e2ab9a830c1beae3a4589a7a68ba4b3ca9d7fd2740da80"
    sha256 cellar: :any_skip_relocation, sonoma:         "3347aef6dd41968ff6d903eb66e8f8bd300e6f08caa5561883ea60b9688796b7"
    sha256 cellar: :any_skip_relocation, ventura:        "8eb81213de839436e2424dd61e25b144de70d1ad90fe76e2b54db4f47fde51a2"
    sha256 cellar: :any_skip_relocation, monterey:       "2cca9969aaa10a0b7efc6733b856344bfd8335055982caaf995c3fbd5d1a11f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e9f362e42f674ad1897dfc273bbd8fb2f1fa17565fa20c8127904d0414ee26d"
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