class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.78.10.tgz"
  sha256 "33365f834c0f7f1e7a8731187eca160e94c9dfd7fc538273f78eac334172d4ef"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "351b7eec600f7ce55b35583482bdb02d5c8b5f6e14a7cd17d8e93ef9102eed39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "351b7eec600f7ce55b35583482bdb02d5c8b5f6e14a7cd17d8e93ef9102eed39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "351b7eec600f7ce55b35583482bdb02d5c8b5f6e14a7cd17d8e93ef9102eed39"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9ef00c55ac55cfe8d27fb42e7f13d7d40c81eb0798c4e548a124f7e3f8e30d0"
    sha256 cellar: :any_skip_relocation, ventura:       "c9ef00c55ac55cfe8d27fb42e7f13d7d40c81eb0798c4e548a124f7e3f8e30d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c38359e94a785ff51467b36c56eb99115eb363bc263a79f6e5d36201d0a5cea5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end