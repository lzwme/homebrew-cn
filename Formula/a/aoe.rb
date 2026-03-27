class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f2bedbf0849a797aa5591d3938b4cea38371cf4274a753b15b1b779997799ace"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "46054dfe6d3b72aaa6ec881b7f397304a67595c331281542120a61abcef13725"
    sha256 cellar: :any,                 arm64_sequoia: "ef198c7d911c0f3a14d0c9671b175ff46e75bc8c96ef2cdce6e2fba8c7d265d8"
    sha256 cellar: :any,                 arm64_sonoma:  "0611644764e9d70059325b69574cc506e73f98c85d1b3bbf83000b9f9b3ccc92"
    sha256 cellar: :any,                 sonoma:        "26fd8ea25ba51c622c3491f94f59cccd4d693f1a4386469faaa6b862174c6bee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af0b441fe4c8b22f360777c8558afc3dfab5b4629fcf851b324ac3ae3fbafc6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abc1490d8dd5cfeeb09714831bdca304944b62bb39c85b1bca9d360afa71249a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"aoe", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".aoe/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]
  end
end