class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.4.tgz"
  sha256 "0eb88c0969a71fd9d7eca1d3b4427f90358a4c6bb36ca426c6ce6c3e16ed14d4"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "cf1010b13b18247f35c574fcd36a21c093bdcbb634bce1ac65297f4d74f8a624"
    sha256                               arm64_sequoia: "cf1010b13b18247f35c574fcd36a21c093bdcbb634bce1ac65297f4d74f8a624"
    sha256                               arm64_sonoma:  "cf1010b13b18247f35c574fcd36a21c093bdcbb634bce1ac65297f4d74f8a624"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a88447476465764fd3ea0980623d362a91926edf584197686b9f88a59f5ecce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dbd7612bb8d8fb6bc2f99aa1e574164b0f8d4c612c5f1939cfd22ae1f7423a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca1f2fc88a52596bb2fb7b61f2cb67213b30507e92993df3b9441817869ab50"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/@mimo-ai/cli/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "mimocode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mimo --version")
    assert_match "mimo", shell_output("#{bin}/mimo models")
  end
end