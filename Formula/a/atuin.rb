class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/atuinsh/atuin"
  url "https://ghproxy.com/https://github.com/atuinsh/atuin/archive/refs/tags/v17.0.0.tar.gz"
  sha256 "9c1bd5e180f53dd98248f582a36a4ead0670d3e155874a7217ec87cab3cea51a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15a6bb0a39177f096442edc0fb7a61ad6d50fc859c8d3820c206d47a6edd5d7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "353279313ae774e20cd2c54699bc3414e60fde8e6482633e93a5a7d67ab38671"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45bbb196fb0b7acd6d8c495d8eb5ed9f29aefbfb822c5fe2f21e1ef07588308a"
    sha256 cellar: :any_skip_relocation, sonoma:         "041eff5795ea16c28454d1763acc154be70b61b84fa0a2d3ab9aa69f3635a118"
    sha256 cellar: :any_skip_relocation, ventura:        "45dd54e53ab7c523ce2dac3f5aad7a4b96d025be1a00bbc389df9be6095f179c"
    sha256 cellar: :any_skip_relocation, monterey:       "3eccc845558d74197aef915dfc4f6168008a5ae02acca4bfa544d7b45b7c8758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e13b23eae2c03e577450561b4f1600699755587ccb667dc60ec5347a3d8ca4ce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end