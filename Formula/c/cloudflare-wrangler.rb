class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.120.1.tgz"
  sha256 "03976cffd191fe1b3eb01e4b07ed1868602bceca54b341708ba1e7eb48acf56c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1c84274054aae6f4a31ad41dd4f42ab7f249ae70539b134c30bd795ad56f344e"
    sha256 cellar: :any, arm64_sequoia: "1c84274054aae6f4a31ad41dd4f42ab7f249ae70539b134c30bd795ad56f344e"
    sha256 cellar: :any, arm64_sonoma:  "1c84274054aae6f4a31ad41dd4f42ab7f249ae70539b134c30bd795ad56f344e"
    sha256 cellar: :any, sonoma:        "f615a3d40aa93ad428921bb18e093b1c165d03245cd560fe6c90f926330f0829"
    sha256 cellar: :any, arm64_linux:   "23d057fa154d6827020f8d090513e20cabfc5d8e6f4037ea9d8deb51b622d14e"
    sha256 cellar: :any, x86_64_linux:  "6d4fd9dfc59b3b035dbfc18fb05a0e994ed8b4b5abe8086175ccb756aaaa16b9"
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