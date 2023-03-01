class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://ghproxy.com/https://github.com/stepchowfun/toast/archive/v0.46.0.tar.gz"
  sha256 "aebf4d2a735809c5158863bef6601f71bdeae346f583dc6d92acaba06d9f9568"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "719bb0abdfe511aac264fbaf37d110a8d7af8d30f5c8f5098f25cdc63df158c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1185a146f8a291ee41e2fcb3ee55d9caddb7e7222d39497b15483903cb55ef92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e552429a39f3e5431cff2f54e27063b1a6a0b830370654d61ac8348128a2bf8"
    sha256 cellar: :any_skip_relocation, ventura:        "76b416a62e93a2346a10a9775109cf72c6ed131618711337221d996805fca65e"
    sha256 cellar: :any_skip_relocation, monterey:       "9ad5bdd6967a848c00f1b53b6d8fec05c9a751d4f382f27cbbe5666561811e08"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a0b7fd7e10439885826024e5aaf480bb4de15a2fea423727dcdc3ba34305072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a16d2f1c2d1f3a5476c52928281e0fd54af01231b14145d3c0a9208d77752d9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          description: brewtest
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end