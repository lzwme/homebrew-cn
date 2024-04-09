class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.4.0.tar.gz"
  sha256 "6ace03f216fcc1ad0252f74a9eb3091c89b104974927a79a9510ce8fa6cb15f5"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a30be53cf91efdb03568daf7fb25a55991d4167a1079be0f6081b80f11c0bf49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0575ea6cf6fc4a99625e80f39ad0d2e4d41bc07eaee781f7f37eb885cd586b54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abee4690dd2eb3a3c34407d262b40ae68eb6a93f9e34edd1dae733b68d5a77fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "53d4c3773723b3439bbea40059dfaea2c59101ca8d2f42186b2d4aae228583ab"
    sha256 cellar: :any_skip_relocation, ventura:        "a6e9dfe236dbe6483e0548c84bcda21b5ffb4b30037808a0507cdda5897608d3"
    sha256 cellar: :any_skip_relocation, monterey:       "7bafab9e43368e268eb45cd7ad7714115f780cfdfcb22898ac6ac147b3c33fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21d0c5bc8822b8e9b97961d053a9488b55d1cc6ec4b2a2c18407e5995015fdec"
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