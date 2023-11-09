class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://ghproxy.com/https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "b132f4335e7cf4d45062cbb609f1048cbac85390f4634fc21253e9143adb3c75"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c51b3a8fc5f9e2507952e7ab3dfc962a3019080d5655c7cc4535b0cf88f7535d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1d9c8033a44aabb3d8edcc574ed1adf8eb24065d5063f41401cef0df1be3ab5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4403c32f769afd7f6a2fe8a2a10242ea6b462ad3cda038a5ccb0db75b6f2d75"
    sha256 cellar: :any_skip_relocation, sonoma:         "14c499f99e8c82d59eae3eef5041c9574fe70e71ca6ddfeeebe5aed6e26256ba"
    sha256 cellar: :any_skip_relocation, ventura:        "67f6330c40c90821b67dcd9463b44750764bdb73cb3a0625c65c7fbf0cd25911"
    sha256 cellar: :any_skip_relocation, monterey:       "6a80b2329630c00cfdd694921ecc43fb49dd82897d6a2a49c2f4c2e34a1a71db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b055a082da6e7ba4e5529914384ce7de3dca74782f18b182b968edf8f1329e3d"
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