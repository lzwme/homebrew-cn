class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "e0c663b6881a28f82ebdec0b6198878c052cf0644c6e1c8cc97d354782f2c05e"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "11d1684adc04c012d40e7126ee357ebe8e39f620c2603ac9d012334b4f450c39"
    sha256 cellar: :any,                 arm64_sequoia: "af2e75fba6973240c379631a0f9ccc1814cf81ccfa375fb3b060df3f78eda3f4"
    sha256 cellar: :any,                 arm64_sonoma:  "22c1f1e5f168f38cb320add4ddc8a145f1d5b0bd834073dbbe81ad11edd1fa05"
    sha256 cellar: :any,                 sonoma:        "ba800c8a3c7818febd1df10e5a586335f870ecf9a6c4a0695b1c2bb819527948"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac986d39ad731651cd5222a1851c90026cd18cb47ce8c7cc6d3314f3a1f10aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91f829d9b698edd7e68bd93697473c41f7639471eec94f6d674e31c3e98a23cb"
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