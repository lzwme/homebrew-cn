class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https:tldr.shtlrc"
  url "https:github.comtldr-pagestlrcarchiverefstagsv1.10.0.tar.gz"
  sha256 "bbed8b11214a0f1df82f82581efcd241b45c3d33dc5f46e488abb017239e7f74"
  license "MIT"
  head "https:github.comtldr-pagestlrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e334912a071e4f40feb6bd430f77c241187ce232a886508694fb965a8097ae83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e85512e197dd083e7243ed29a6b4158fc9546d9b930af69a7c6514934cc2d702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e68907aab93b08dbec91512c8b0bc925ab3cb52ce7e3c451aaeaac4e9fa45d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "300bda69957eb2d20c33dcb7a6ec29fcd500d5b9f8933fbc20e7c17db911f6b6"
    sha256 cellar: :any_skip_relocation, ventura:       "dd35167b9491973f40b377d95f4e21675af27d92b606a7a307783dc854286b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "149fb05039dfba382b6bc05b00ab06ef1dc6e6934b9252ff1ce55a1d1ab22e36"
  end

  depends_on "rust" => :build

  conflicts_with "tealdeer", because: "both install `tldr` binaries"
  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "tldr.1"

    bash_completion.install "completionstldr.bash" => "tldr"
    zsh_completion.install "completions_tldr"
    fish_completion.install "completionstldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}tldr brew")
  end
end