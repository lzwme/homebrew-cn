class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.4.1.tar.gz"
  sha256 "cd7d46191b85ff85012b33b84bb7f488b38f60e82daf87f159ce9d366f74a2d3"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af13ddd6182c4ed003dff487db4175921d30bdc67e6183b8aebbca6205c2ac55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "128b0692247b24dd32d0ac8bf0087ec3c1168898e8ee75dd5ed7f7814da49202"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e398c2e08df07df963cd53614ddf91089632f947c5f6791b7383ddc68fc937c"
    sha256 cellar: :any_skip_relocation, sonoma:         "85c22fb88e537e5a7254d541669cfac43e1e9584634497e9d2d5df5048d3b529"
    sha256 cellar: :any_skip_relocation, ventura:        "92130c30b5ca569233ca9c50156dacb11d8524d27bce801b2714c69e1f99ff66"
    sha256 cellar: :any_skip_relocation, monterey:       "7a5da5275728170d9192d75c8c4bc56384559e77abd15e231eb761c7aee87fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b69632d4f7c7b4150f697fb9fa518cda3bae0f092dad796003b45a0b43679ff6"
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