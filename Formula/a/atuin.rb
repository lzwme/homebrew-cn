class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https:github.comatuinshatuin"
  url "https:github.comatuinshatuinarchiverefstagsv17.2.1.tar.gz"
  sha256 "5bad59af24317adfa1d56fce39e231c85836fb91ac3d468830f9bb0884b320ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c543ecb375d03c396636bd7a9a20e29ece8455590777c33fc963d10dc3301d39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a861b3a5d374279e4dbda969a381a2af4ae3e529fd44edeec3c261adee630217"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7472ea2eae84b5c5972c28398b80c9a0f5fb0815686b7c324ac872a1fcc5843d"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fa661a65595fb2343e38a77a8a8692b03bee1c531a60245e8dcdaefc668b835"
    sha256 cellar: :any_skip_relocation, ventura:        "66dba7ffefac9ebddbe42ad3059ebc7bf3fb35999fbc9ef97a2bcea78797ddbb"
    sha256 cellar: :any_skip_relocation, monterey:       "0e5486c3c72f756b6fb01aa07005e259918fc55013a22d833d96b7b0071fc56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09861fd29021ab41d847f4a1002188e89d4147111b7a235673deaa207399934f"
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