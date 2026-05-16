class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.91.0.tgz"
  sha256 "b9159d0f66f84ff0bf29fa63f1d09d66f40138c9e34c870e9a83bf21239e9331"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07eb27f3cf88b44425ef8ec5e8537111d49681c57fed4e2c4ba62ac3491c5195"
    sha256 cellar: :any,                 arm64_sequoia: "c5392a27e5b900f3cbb44eef480b315ea7dd06cb2bdf76daf6f7208d8809bfa1"
    sha256 cellar: :any,                 arm64_sonoma:  "c5392a27e5b900f3cbb44eef480b315ea7dd06cb2bdf76daf6f7208d8809bfa1"
    sha256 cellar: :any,                 sonoma:        "c24c9c4a779b081dd035231d2e5cb80d2762a9567cee83ab7ea8bffd7bff8c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d161930b77b986cdf5bbb07f79efd7d4da5e4589c4811befb3f8db77f3a33fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9081f29281c233568508c7840629201cbed3ce905865787375e7b456d7b21e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    generate_completions_from_executable(bin/"wrangler", "complete", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end