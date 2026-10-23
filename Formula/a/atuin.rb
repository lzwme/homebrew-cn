class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.24.2/source.tar.gz"
  sha256 "1b52539da5d55962dc284fa10a78cf5dccc2961fd32af6812bf3d5969f632d9e"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2e78b48b0d1bcdbb13df1d126c68db2ad7f08d36c1c3bdd76af0d927af8024c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37dda6475c3e01e8ac9d0912c5b114f2ca090c20a883b41886e19eed716956f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5467d93460397e71bfbbb6e2051570009be0e983a92ad8963167fb86a50c3bbe"
    sha256 cellar: :any,                 arm64_linux:       "79725fb5631e3f1e7317841425094b7c827a489ad509d45fd6b2df856c209f75"
    sha256 cellar: :any,                 x86_64_linux:      "63879ef30272b9902f81fb755eb03ffe6a24871f440a039070686bfad9a6d69d"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
  end

  service do
    run [opt_bin/"atuin", "daemon", "start"]
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