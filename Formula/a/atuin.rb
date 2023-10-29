class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://github.com/atuinsh/atuin"
  url "https://ghproxy.com/https://github.com/atuinsh/atuin/archive/refs/tags/v17.0.1.tar.gz"
  sha256 "b03d3a1597ba2bbd784612e730419c2cdc099311adf48518bd9c00d2799199f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b6df849ac3f9f25d46e048bd41b64424059d77cfc4fdc7b16d6f35b8dc8a79d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fd5c4be986b1270466b08b32ce2917282435fc6a9bc1c4b22c6db54be02bf68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02f6904ec58293835093f8bb56c378afee5066a9afafcdd37a96ebed3f52fd30"
    sha256 cellar: :any_skip_relocation, sonoma:         "2439cfbff77749f3477f568340ae899696bb5535a29ffc9ab467824ce4694665"
    sha256 cellar: :any_skip_relocation, ventura:        "b92efd7c54b1b22d0b42178619452e5536222785eef4cc4e17bb016e552949da"
    sha256 cellar: :any_skip_relocation, monterey:       "5c5fa0ba24764691a2d0c79e47e4088e5c1b64fd855e32db3aa856eb8838e095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6aed45e0e23ab4a98ff98428a248e2524546f583f71e5ce183d13b534bc78f4"
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