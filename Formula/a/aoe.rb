class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "539d04e8a9a22166b0d27d6a525a6eaf2f50d85a0635d6d28af8adfe1c232967"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6d26e730ffbbf2aab085fe35bfce52458aaefe750bece08c307aa33d5c924eb"
    sha256 cellar: :any,                 arm64_sequoia: "882fbe2d12fed468cbe8ebbec1ae1a04e0075fc344b417037b432b3a51699878"
    sha256 cellar: :any,                 arm64_sonoma:  "d0e8dc995aa39a9c6b183493cce96a32fb7bb29b5f946cead2ecc868c57c4bd5"
    sha256 cellar: :any,                 sonoma:        "b6962a5ffb929a020f9b1c2204650e3bb8eb4d09760f4445b5ae8ddad16142ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3377bd6cdfdd9a31aeb0b71a980caae12e16ef3e3bd345f8c4c7312bf0dbe58b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27ed825493731221b4643c8e8e6c74eaf56b358f2501f54e7f9909c071f5037a"
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