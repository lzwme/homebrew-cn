class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "bb12b0c1c9ea2bb1f4430f3afd1a353307abaa16bd77c518dc78f686c38e5a26"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "099109db5a1f0eb1c4f784982329cf1d92762328cb4add5fe7ae6b751ef550c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50fb2285d4ad7035043b8dc1b4b5984bb4586b3afe0fc4d89f7ae11ce2eb9617"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4f1ad5c5497b5791370b31e26573865f38f89dfe4a85809183b556827fc22a6"
    sha256 cellar: :any_skip_relocation, ventura:        "ce09a3e1b1a865b47f42b3f3d5b7bde523f05f3bf8d62021b2f8f4368870fdcf"
    sha256 cellar: :any_skip_relocation, monterey:       "15e39a19cee70d78bb3213d3439ac4b1774f8a86871149ce52a4a414b8259527"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d89a76feff69580f971d12dc75ce36bd665ec15377c6a50bb454768fe00bc6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0d23102bcc25d1c0ea5d232fb47369e145727bc2ac9e788a5589887b0a2bc56"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end