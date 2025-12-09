class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.2.7.tgz"
  sha256 "817bdb4d08a49a2602e1432317028fd2c1b391ac4913efc8c72c927ac35301a4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08779b73e16abb43eb6955ee7902c00784f692181c2dd67b2999576a1e9a659c"
    sha256 cellar: :any,                 arm64_sequoia: "5d7c7983bb7702dab7e3c386f9ba4f472497ef57b12d58c51a0bf8bcb17d2597"
    sha256 cellar: :any,                 arm64_sonoma:  "5d7c7983bb7702dab7e3c386f9ba4f472497ef57b12d58c51a0bf8bcb17d2597"
    sha256 cellar: :any,                 sonoma:        "3960d0fde96109a5da7634efb54445d6b1aa1a9a6feef889ec6eec50beae0165"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50bb566c20f8f5c1fcb96922d3fd828af73a2e19403020624a6d3b199dc2adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9b9e835485e4b9135c740a440dcac3f89721199d62da2f6bfa1afa6e55b20d1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end