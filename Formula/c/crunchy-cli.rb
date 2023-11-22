class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://ghproxy.com/https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "24bf02b777c19ef06f6fa19dda82fed96751de0e2281b0435dfdc5442b36469b"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "532c5820922d3726f2203a01794a5b82731f63e522776580283c141993d78cdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23353c1dc577b258c4d6414fbbfca0b6275f44600c5c10a38affb8c70e21a095"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f670556d4f3fd0be99bf890caf90a5cadd0c529135c18c1e85c194a235009836"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4471073b3a600b51250f4553f1a50cf76647984eb83392bd1baef38ad157419"
    sha256 cellar: :any_skip_relocation, ventura:        "0d65a74c952b9d0ecbe502680399709efbe053110e25d216d9b7c425183830d3"
    sha256 cellar: :any_skip_relocation, monterey:       "322faacdceb241eb62548056e097580f23989cdd733a9d632e33ae01e7d66f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f880fb00eeda12c7b2c44139734321fa31370f00ba4062f94ec24823732334f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--no-default-features", "--features", "openssl-tls", *std_cargo_args
    man1.install Dir["target/release/manpages/*"]
    bash_completion.install "target/release/completions/crunchy-cli.bash"
    fish_completion.install "target/release/completions/crunchy-cli.fish"
    zsh_completion.install "target/release/completions/_crunchy-cli"
  end

  test do
    agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/119.0"
    opts = "--anonymous --user-agent '#{agent}'"
    output = shell_output("#{bin}/crunchy-cli #{opts} login 2>&1", 1).strip
    assert_match(/(An error occurred: Anonymous login cannot be saved|Triggered Cloudflare bot protection)/, output)
  end
end