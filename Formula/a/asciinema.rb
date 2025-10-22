class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://ghfast.top/https://github.com/asciinema/asciinema/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "f44feaa1bc150e7964635dc4714fd86089a968587fed81dccf860ee7b64617ca"
  license "GPL-3.0-only"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82fe6b5f0fa0495650b1d975ac49cce325a678f9a45156f1d8c61198495ad5e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d34c430b96b73a4234361b905406eb59f71dd147b852e6e7c3c6fee34766ecb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5ecebf8821fbb1321ac786cf08eac4be6e78ce2dd95b47de8489d6d45ae57ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e9e7b372d88285ed13f113c3ca980cd765e5b92d2da151ec11e8829cae14eb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9f8c435dddd40061f375750212d855d93e1ead60097f3ae0ff6096b11077294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c1ee8e73712f1c02305ffa594af94b58e5f1678ec30a36b960d4b847191ea6e"
  end

  depends_on "rust" => :build

  def install
    ENV["ASCIINEMA_GEN_DIR"] = "."

    system "cargo", "install", *std_cargo_args

    man1.install Dir["man/**/*.1"]

    bash_completion.install "completion/asciinema.bash" => "asciinema"
    fish_completion.install "completion/asciinema.fish"
    zsh_completion.install "completion/_asciinema"
    pwsh_completion.install "completion/_asciinema.ps1" => "asciinema"
    (share/"elvish/lib").install "completion/asciinema.elv"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["ASCIINEMA_SERVER_URL"] = "https://example.com"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to authenticate this CLI", output
  end
end