class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/archive/refs/tags/v18.9.0.tar.gz"
  sha256 "a410fc85d3b11b804ba24f73f4a655ea8252f0198b9208a79474b4d9779f32ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c203f765442d24a4ebd09efef875e29090b38f78c4e45db24f6289d49187fd1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f959d50c6fc34e78b0d2bef243601946fb2934286cb9475403af53bc5f7f36e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f1d55e06dd9635edb2ade85f9b0eed2780f5380400658f9cb3669668c1fe86e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ce288cb9c6ee1130d836abdf04479980b46cbf4b55f9c3dda0036b5a97560c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30b93c86d2f107e673e1bb2df63b316a88daca1c38d842753e83dcbe89264ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acc4a821f78adce039cd785d2dfd14568274ab3b4e05ac40eb2835259f66cd3d"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  service do
    run [opt_bin/"atuin", "daemon"]
    keep_alive true
    log_path var/"log/atuin.log"
    error_log_path var/"log/atuin.log"
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end