class Noseyparker < Formula
  desc "Finds secrets and sensitive information in textual data and Git history"
  homepage "https:github.compraetorian-incnoseyparker"
  url "https:github.compraetorian-incnoseyparkerarchiverefstagsv0.18.1.tar.gz"
  sha256 "065729ad1c2b3c618603f0eebfff1a235aaa6fe44fda64dc535f63d9466fd44c"
  license "Apache-2.0"
  head "https:github.compraetorian-incnoseyparker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eca50788a846a424fdc503f8c8e47099180391dcff57ed35b2561c8d5a345508"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "443da5d69a86795794aaff0f95a5c38ae02224ba16cec02d086b2fc7a9e472f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3a977146968cec30dc650baafe9087460d531fc8f9f8104f4e9540cc03126fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "96a2f93b435c0129b66cf998fc8b41518a7db5ba9668f30e6e730ef7f8d59d8e"
    sha256 cellar: :any_skip_relocation, ventura:        "2a68b236aa2baf366a87767cd58daf3efe5adcab0b0af66a62d52571e340ecad"
    sha256 cellar: :any_skip_relocation, monterey:       "1796d6dc599a1ea7242cd347289cb5055897cd1dfb29964171ea4147b28da1be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59ad3090724af7999d21a9ed072a605ec05c01b243c840ff6ec09a5c30ec337a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", "--features", "release", *std_cargo_args(path: "cratesnoseyparker-cli")
    mv bin"noseyparker-cli", bin"noseyparker"

    generate_completions_from_executable(bin"noseyparker", "generate", "shell-completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}noseyparker -V")

    output = shell_output(bin"noseyparker scan --git-url https:github.comHomebrewbrew")
    assert_match "00 new matches", output
  end
end