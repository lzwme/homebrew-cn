class Aicommit2 < Formula
  desc "Reactive CLI that generates commit messages for Git and Jujutsu with AI"
  homepage "https://github.com/tak-bro/aicommit2"
  url "https://registry.npmjs.org/aicommit2/-/aicommit2-2.5.12.tgz"
  sha256 "c2b72ffb6819d04eea6508e0b648693a07f28d819b623de92e616705db31f888"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f89b8f87f48afe090c34f06643d9339498f688fb16cb032764a0e07092f936e"
  end

  depends_on "node"

  def install
    # Optional dependencies include `@github/copilot-sdk`
    # which uses proprietary license
    (libexec/"aicommit2").install buildpath.glob("*")
    cd libexec/"aicommit2" do
      system "npm", "install", "--omit=optional", *std_npm_args(prefix: false)
      with_env(npm_config_prefix: libexec) do
        system "npm", "link"
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aicommit2 --version")
    assert_match version.to_s, shell_output("#{bin}/aic2 --version")

    assert_match "Not in a Git repository", shell_output("#{bin}/aicommit2 2>&1", 1)

    system "git", "init"
    assert_match "No staged changes found", shell_output("#{bin}/aicommit2 2>&1", 1)

    (testpath/"test.txt").write "test content"
    system "git", "add", "test.txt"

    assert_match "No AI provider API keys configured.", shell_output("#{bin}/aicommit2 2>&1", 1)
    shell_output("#{bin}/aicommit2 config set OPENAI.key=sk-test")
    assert_match "key: 'sk-test'", shell_output("#{bin}/aicommit2 config get OPENAI")
  end
end