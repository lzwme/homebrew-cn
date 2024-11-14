class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https:github.comblacknonhwatch"
  url "https:github.comblacknonhwatcharchiverefstags0.3.17.tar.gz"
  sha256 "29ee3982626fc3ee498d7aa60a8a88c5b62f1832d7696eba3104c7012eb6c4e4"
  license "MIT"
  head "https:github.comblacknonhwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60c5f14c344ff9ab60e1770a1167728ef324a4772e8af2e7cba575e2944acaa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f9bb6213f71a4d45b6210bb827ec65901725cc020a47cbec3d6be4417ced7c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a81c265b0afac984e57bf2b96f4e165fb26f836aff436e2fee4a5ec9a2cdf22d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a21b743cfeb8b5fc313ba60c9f489ecff26290d0ad324e00fb808c2e90f6aad8"
    sha256 cellar: :any_skip_relocation, ventura:       "2241ec8940b332ca244cf2ed736f7a4f05e48918a35e8a6ac6eddcb856c363aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d47db940ecacb95cb065e4ed6f4c2fc0ef21ba14eb1cdff2154aeeb1311b6d6f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manhwatch.1"
    bash_completion.install "completionbashhwatch-completion.bash" => "hwatch"
    zsh_completion.install "completionzsh_hwatch"
    fish_completion.install "completionfishhwatch.fish"
  end

  test do
    begin
      pid = fork do
        system bin"hwatch", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "hwatch #{version}", shell_output("#{bin}hwatch --version")
  end
end