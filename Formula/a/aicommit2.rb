class Aicommit2 < Formula
  desc "Reactive CLI that generates commit messages for Git and Jujutsu with AI"
  homepage "https://github.com/tak-bro/aicommit2"
  url "https://registry.npmjs.org/aicommit2/-/aicommit2-2.5.21.tgz"
  sha256 "7d54567cc8c471c040986b22b6578ec11a8040c0f589b823d00f064266a90209"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d68ac199f6337a0db64f15ed394b170b31796af90879ec0f342830bb230006a"
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