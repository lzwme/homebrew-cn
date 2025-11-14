class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.48.0.tgz"
  sha256 "f42fbb8088a09968b587ae23edcb96856dd223e747d8ce58e7c2750b4a44669a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "798eab71ab35e15d4b87569446256786f807cb94602746f6d893c50f4944e883"
    sha256 cellar: :any,                 arm64_sequoia: "ef5fd10e8d4c6a602cc2d7bf8270f079d8144954dd0cd9ecf01747fcdc02309d"
    sha256 cellar: :any,                 arm64_sonoma:  "ef5fd10e8d4c6a602cc2d7bf8270f079d8144954dd0cd9ecf01747fcdc02309d"
    sha256 cellar: :any,                 sonoma:        "a3ceb8b9ece5a9ed50982c38423fd253c7b105baec198c2378a88eadc3b69e77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f40607d65aaae647f4e345f56698656fb045dbbf2529a493a669f95ec1b9fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31ef8b99055751dc63c19f1ba9217fe9f8ecd00f628714cb0a90a19d14f65d96"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end