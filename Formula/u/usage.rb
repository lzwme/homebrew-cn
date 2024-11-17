class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv1.3.2.tar.gz"
  sha256 "2fa15f57ab5e8519438bce2f88452ffd2a0533fe6cc2ad520345b382946b13b0"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fafe5fc2a51eee39f48b1a0378492fb5b9c58835446ed25037fc71fc3a51e15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46da55abb37b17b09c102aba0cbc4af2b4b95b152cea89b353d163bfa0eac099"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7dfb23fd7f1f155d0340d920ce72639dfc9feb06d87a41aeb4b97ccc33aa82a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b2d8923f79010ba2cebeac1bdabdc021a72ccdd8fa5628405ec4eff2fcb47ad"
    sha256 cellar: :any_skip_relocation, ventura:       "dba812792b7734d174e8c73988d9ee5e60abf2cc4f3b34a5a3ed3ee476ca742d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6c3ff1fd9906de91519779a27d8ada482d6676f7133d06f4f084a6c04f3e2e1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end