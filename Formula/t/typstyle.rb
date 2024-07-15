class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.11.30.tar.gz"
  sha256 "330d58f348a64c825e1bf86c5748b11bdbb25c6d72a97c0623d12f01a8af7226"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0d73ac4da5ac28263305eaffc186f9c6d5a1e4dbecbf26ae3f32f333afeefb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13c11d8254fb54e0df3a0c1a40437fe40e215ae2498cfd9b887bf463fb04380f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24a0ae17c6a25014f9c5eafeced2940c283c3665f501d3ec695b64a511601804"
    sha256 cellar: :any_skip_relocation, sonoma:         "01344ffc7f3b7caf6c9104d65c554d73d1a766d78118e20ec7ed439de5b861e1"
    sha256 cellar: :any_skip_relocation, ventura:        "14973623dab83d22d56189d7ad1d7ec2d32b38d706172d6d1a89a7859b0002a3"
    sha256 cellar: :any_skip_relocation, monterey:       "b3aac23471392f4686a61ca6ddb5da12faf313be403aabe51a403df7b08d4af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7189e1bd70d760a6143cb5efa3dc460d92b91bd01977c959fb9d28b297a4fad3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end