class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.3.5.tar.gz"
  sha256 "0a19900d40e6e65042308280268686380a9de091dd5679f54ce75719ae7acb02"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ae991df086f5affac7bf50927c5999529eea3f1d440c27a829e0afea374828d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75e69cfff2b16f3ebaa5f8a6c47bd03d6834d92a1142da5d0eb23ee2e4331895"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "371d1180da2e8f53a9f26849d7a18cfd2421d18856a1a2e9e14f55d612f1a3e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbf129e146e36d8c95a26d38095fad3add524317bf789f3c85cff40f467baf31"
    sha256 cellar: :any_skip_relocation, ventura:        "2a8b4a2df2c728ca1204138823a631740098cb5bc0be8286ae516ac819f79c4d"
    sha256 cellar: :any_skip_relocation, monterey:       "381c5bb5b35f6e76c41545f8ade9be327dc69b0fe4df7adcdfec101711981d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca818b82fec1d3bf19a3a0551ecb5744039dea61d36b47ae5d737558a59cd2d0"
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