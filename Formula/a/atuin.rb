class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https:atuin.sh"
  url "https:github.comatuinshatuinarchiverefstags18.6.0.tar.gz"
  sha256 "a79cdcce09d2910e64c86e1f57d58a2214a76031df46782860187835c11fc99e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09e749e3348b80a6ac5bb0a1e67fba54b02b17e7f362a6a3743e34d01cb18e50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d77a0cbd93ef538aaeb82138cad91189e93cbf67f868c6279ee5101574311e64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5db9cc60dbd87c49e0930b6cd679028a0185a3c80445534cf10fe239ba65884f"
    sha256 cellar: :any_skip_relocation, sonoma:        "12b626af1ec661f36df37eb7710a07a7fad470a5c13941d6beabcceb89ba6a5e"
    sha256 cellar: :any_skip_relocation, ventura:       "6b05183b1153f7b582385d80c6ac861aadfa48c820a7eeb6722c7a100dad0521"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "987ad3b247eef6fe9dc4030165d27bc366fc796c97555d13a5ad79039767a7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "509d36e50161e9d9666e83b0dbce0ec1650b4ee07e6bf7c625447f43619455d0"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesatuin")

    generate_completions_from_executable(bin"atuin", "gen-completion", "--shell")
  end

  service do
    run [opt_bin"atuin", "daemon"]
    keep_alive true
    log_path var"logatuin.log"
    error_log_path var"logatuin.log"
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}atuin init zsh")
    assert shell_output("#{bin}atuin history list").blank?
  end
end