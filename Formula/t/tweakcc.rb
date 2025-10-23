class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-2.0.0.tgz"
  sha256 "a74cae9a7032b8870d01b89a986954f9fd19311931d6f0be79849ee24a566441"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3566a97b3aa81d928cf4a21c263a248897216b55dcec8f400cf2e26e9e94be92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3566a97b3aa81d928cf4a21c263a248897216b55dcec8f400cf2e26e9e94be92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3566a97b3aa81d928cf4a21c263a248897216b55dcec8f400cf2e26e9e94be92"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef1f74bca09d1e168efd09582c5d843e2b087d46390df2be0ecf55ef6405cae9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef1f74bca09d1e168efd09582c5d843e2b087d46390df2be0ecf55ef6405cae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef1f74bca09d1e168efd09582c5d843e2b087d46390df2be0ecf55ef6405cae9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end