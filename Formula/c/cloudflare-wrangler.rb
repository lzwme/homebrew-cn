class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.123.0.tgz"
  sha256 "762e002dae5fb41027855065aafd8f6703bdf358437cf37946aafe5092add9cc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5fa1f61abbb70fbfd2d336d32f7b00b6ad50ad80a8d0031a77744ba41aef6102"
    sha256 cellar: :any, arm64_sequoia: "5fa1f61abbb70fbfd2d336d32f7b00b6ad50ad80a8d0031a77744ba41aef6102"
    sha256 cellar: :any, arm64_sonoma:  "5fa1f61abbb70fbfd2d336d32f7b00b6ad50ad80a8d0031a77744ba41aef6102"
    sha256 cellar: :any, sonoma:        "c02b7a5e0f6a609b7217a83d3f401328c5b06cf930f552a64fe33179436a78e3"
    sha256 cellar: :any, arm64_linux:   "cdc87bf35c6a2197d740f33c5df32be0f5db304bdac189192c185d280df7b849"
    sha256 cellar: :any, x86_64_linux:  "942a81dc17f94c80799281cfa6612a5bc4a4dbe73cfae1efaf8ba4efb7da854a"
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