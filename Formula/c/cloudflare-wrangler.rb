class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.96.0.tgz"
  sha256 "af06f460e7c1a262ed77c7ea933fe7e05db9e5ac44cd8895963ae47c575f78d8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "878f9508869a6e0d23a347767280123b545ef7366b4ae0e785024fef125b0156"
    sha256 cellar: :any, arm64_sequoia: "47c5f46b0799a44b7dee59b4a9db4924e93683ace9ea7b8417ea252724b04858"
    sha256 cellar: :any, arm64_sonoma:  "47c5f46b0799a44b7dee59b4a9db4924e93683ace9ea7b8417ea252724b04858"
    sha256 cellar: :any, sonoma:        "c695b70b3e856207144decc0a6a03755f27f3ce09833a9f2abbdc1fb5ed05908"
    sha256 cellar: :any, arm64_linux:   "5fdfbd7a06220d153eda43c954319adc1d008d861dbe494d5f90942f5ec8f2c7"
    sha256 cellar: :any, x86_64_linux:  "aad81861b9bf16b420cfe3f318f94057ec10aadb847413bb2038bc095f8afcf7"
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