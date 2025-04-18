class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https:github.combensadehtailspin"
  url "https:github.combensadehtailspinarchiverefstags5.3.0.tar.gz"
  sha256 "1bd959e1fc4f095f0237170c9f88fb0b6b70b7d975a21c6f26ef3b484ad655f0"
  license "MIT"
  head "https:github.combensadehtailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b06137776692c312d16d8dd8c540e2e48fd5531db0ec6d02ba18bf099fc3e35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ba8d53565f25f838f333d35650c64db20ac45a3832f30b9fb6573b590dce908"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b64bf61c722c393cc8c1b76b1b217f37956d92952b6a487924efc23330b6aa32"
    sha256 cellar: :any_skip_relocation, sonoma:        "efbf6f6908008c60a206a7b6223a512632f698690e930d838af67018897ce0a4"
    sha256 cellar: :any_skip_relocation, ventura:       "6f5ce9ac4d9b6ad49dfd6aebf7b1d34d73d13c7a85d90e104913de23ce02031f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2013a9d5d6e5a3e245d19b94d3407fef96d285d8de3708007d5052305929f54f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c4fe34eada80680c73a409d26bba3c988b995bc530c6439e4084e8593b7244f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionstspin.bash" => "tspin"
    fish_completion.install "completionstspin.fish"
    zsh_completion.install "completionstspin.zsh" => "_tspin"
    man1.install "mantspin.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tspin --version")

    (testpath"test.log").write("test\n")
    system bin"tspin", "test.log"
  end
end