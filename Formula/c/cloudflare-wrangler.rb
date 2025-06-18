class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.20.1.tgz"
  sha256 "f899f3bdfb4a36a88cba25964c2e87c8a0c7b07ffa036b9be6b115aec68cab7b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a73f8b3d9cd323a23216f08809d443f1abd6c6c153f32c3e7f689feac29e3b46"
    sha256 cellar: :any,                 arm64_sonoma:  "a73f8b3d9cd323a23216f08809d443f1abd6c6c153f32c3e7f689feac29e3b46"
    sha256 cellar: :any,                 arm64_ventura: "a73f8b3d9cd323a23216f08809d443f1abd6c6c153f32c3e7f689feac29e3b46"
    sha256                               sonoma:        "44b170c368be7a312ff22705b109845179369707b4814825f51f0155a32eaff5"
    sha256                               ventura:       "44b170c368be7a312ff22705b109845179369707b4814825f51f0155a32eaff5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a81b517511b3386afa28094aeb18a98e5b1705b9a04168872c81ef1dec4bcec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4579763db20e7def7bdbc133fc4ce9115f5ff10bdb3d94ce08ecddbc5e8b2bd6"
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