class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.120.0.tgz"
  sha256 "c4afc0eb5bfc595ae7f6e68e3689728a39ed42e0ad160f9fe01616fbf59ac3e3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "562b2c58018347b639a64e1c316c559c91e6a5512d8e9d13605c197d4f561d90"
    sha256 cellar: :any, arm64_sequoia: "562b2c58018347b639a64e1c316c559c91e6a5512d8e9d13605c197d4f561d90"
    sha256 cellar: :any, arm64_sonoma:  "562b2c58018347b639a64e1c316c559c91e6a5512d8e9d13605c197d4f561d90"
    sha256 cellar: :any, sonoma:        "2c8509ddf821a3616b846185d421266317ceda6a550c6035a6999ee5d510167b"
    sha256 cellar: :any, arm64_linux:   "da9f3cb78e42d6a03ab92f60e83f4f78d15f065812b4b7632693b07d29653e91"
    sha256 cellar: :any, x86_64_linux:  "f42717e27bcca9bac5941f2d09ebc22093097f161c06fc18edcc72964014f128"
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