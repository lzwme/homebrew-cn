class Jsongrep < Formula
  desc "Path query language over JSON documents"
  homepage "https://github.com/micahkepe/jsongrep"
  url "https://ghfast.top/https://github.com/micahkepe/jsongrep/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "2db5efbe33cdaba5b93d8a884baa12049b17174d839dce25480551a5fb358375"
  license "MIT"
  head "https://github.com/micahkepe/jsongrep.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bba02a4fd363dcdfba0a4344641700736f01af22e4c1712b84b26aae6408770c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0e9ff382e4ecc552ca7291f0584640c22d254349ae2e3e07025015f215cdc85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b109c2f1d54cd1c9aad9d043627c8fddfbb12a05db6c7fa5676a7287738be6ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "270f1a9a6fe88487635329c247d05bbea4d2910446840f4c7370ffb003be730b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a3647cee9ff9e213ab400e94d4f200b98a9a8101258f4b5842c67f8ea0ad7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5737015d93e6af318b563d176e1ecb7347d92cd02869f745f13d89e55aaee9bc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"jg", "generate", "shell", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jg --version")

    assert_equal "2\n", pipe_output("#{bin}/jg -F bar", '{"foo":1, "bar":2}')
  end
end