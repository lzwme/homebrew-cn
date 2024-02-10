class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https:github.comatuinshatuin"
  url "https:github.comatuinshatuinarchiverefstagsv18.0.0.tar.gz"
  sha256 "02b26d15de30da5fa8ee16bc6b9f03e2e644f5d39ef85dd251998915dc6e5fc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c77ebd7c1389141c3fcfb821c79fa261cdc22ff1d312cbbb76f4325a30162e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c54f44b8a0a28780e9e12c609a25f7e551885337850e43a0bfb7e3227dcbb2e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ce6d553988a354a9dc26e9446fe75b5420efc67b8cfde8c8267617b18dcd153"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1a12972eafa8c4c2996d92714836af43add0afb89cab720640afac5eb1ae1d3"
    sha256 cellar: :any_skip_relocation, ventura:        "fec3d77c470d21199262cb67aea42888b308ec1b2430ead9175cf8652038a17a"
    sha256 cellar: :any_skip_relocation, monterey:       "7c8f6ff7351cb51245849ce4150e99a6aa9995925dd83248dcefbfcf818dfe10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f5ef40e029dbea5f443bd3e94c302c8058904e3fb2675017908749f6fe193ce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "atuin")

    generate_completions_from_executable(bin"atuin", "gen-completion", "--shell")
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}atuin init zsh")
    assert shell_output("#{bin}atuin history list").blank?
  end
end