class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https:github.comastral-shuv"
  url "https:github.comastral-shuvarchiverefstags0.4.0.tar.gz"
  sha256 "d4a734b4179ac56aeb23b986eb5e2324360eab45080d4d6fca1afa18b20828f8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comastral-shuv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8e1c4a876c3ec1ee6036bd7fcf92d53f6841f07a5aae8c47b4e05a617ac2975"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43e8fc556b5a5fe7226dd68d5dfa27d9fc1aae348ad146ccb0da53c74ccee6bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94e117d6d57ac2ce22fd3e24cc67c91ceeeffa835e66a8e46443ff53d5260815"
    sha256 cellar: :any_skip_relocation, sonoma:         "b070ff80f5805dc8d1a9c3976cbcfc2976aebe958bcb473fd6d3807d596ba0c4"
    sha256 cellar: :any_skip_relocation, ventura:        "725ba8b2feb2b4e147b6b5938750f4bbb92088aa3877b814db6211f42fb11f28"
    sha256 cellar: :any_skip_relocation, monterey:       "1a6465e343c4f267de2297afa6c5365c2cc319b0e30a56a47999b6fac92c510d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "879be6a08e31c6dd73b5c41fa0abd970fcbf3a1fe0f669130bd2cc80819130ef"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "xz"

  on_linux do
    # On macOS, bzip2-sys will use the bundled lib as it cannot find the system or brew lib.
    # We only ship bzip2.pc on Linux which bzip2-sys needs to find library.
    depends_on "bzip2"
  end

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesuv")
    generate_completions_from_executable(bin"uv", "generate-shell-completion")
  end

  test do
    (testpath"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}uvx -q ruff@0.5.1 --version")
  end
end