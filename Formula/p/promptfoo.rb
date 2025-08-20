class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.117.7.tgz"
  sha256 "4fb8c4c0616de8f10b2ed28d144adb6539667724245eb81fea6b25404ba72be0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "995855a5261b682b3350ed0e9a29391949ab780480d3f6414fad5855d7971e54"
    sha256 cellar: :any,                 arm64_sonoma:  "73347b1b0a00c6c3098735cba82896940289dcbda1178339e67918929b1985a1"
    sha256 cellar: :any,                 arm64_ventura: "8fe8000c6e8c4bd165df917688ced10207a075415510c91eafeac750e2ac5ae6"
    sha256 cellar: :any,                 sonoma:        "9e42750688f93277b29e265dfcc09978095a96597ba59a390e82ddd30fab531b"
    sha256 cellar: :any,                 ventura:       "0c1fc08de8b9d5e3fe7db5a7dd45fc508fabcf5904d88a0da74958d6c70f8ff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fa8f5c625d3f83c38a9ee1c2b308a773a9ba6b9b7fd67e61b2dcd0923bdb36d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc721f911d41e919d89c3dd32e71cd678be745a788a4be8ee608bd2eef240277"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end