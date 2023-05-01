require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.4.0.tgz"
  sha256 "5f4a22162c02f664ba4f9af09098184c90e58a35b69886dd2d85f6fe0f88f9d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4698b80a1389aca0db114ecb4c7504f48cfb31cf30a00b6b7554b97b9f0153c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4698b80a1389aca0db114ecb4c7504f48cfb31cf30a00b6b7554b97b9f0153c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4698b80a1389aca0db114ecb4c7504f48cfb31cf30a00b6b7554b97b9f0153c4"
    sha256 cellar: :any_skip_relocation, ventura:        "e2a869a58c1797c9712b2d0eaccbf5845b2d9c37e2ebda9f203d0eefc12f59d0"
    sha256 cellar: :any_skip_relocation, monterey:       "e2a869a58c1797c9712b2d0eaccbf5845b2d9c37e2ebda9f203d0eefc12f59d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2a869a58c1797c9712b2d0eaccbf5845b2d9c37e2ebda9f203d0eefc12f59d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3349ce80cc630074a47c1d3f0137e41bf3342832908120d3d04f4e4231ded801"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath/"test_cases").write <<~EOS
      GET https://httpbin.org/anything HTTP/1.1
      Content-Type: text/html
      Authorization: Bearer token

      POST https://countries.trevorblades.com/graphql
      Content-Type: application/json

      query Continents($code: String!) {
          continents(filter: {code: {eq: $code}}) {
            code
            name
          }
      }

      {
          "code": "EU"
      }
    EOS

    output = shell_output("#{bin}/httpyac send test_cases --all")
    # for httpbin call
    assert_match "HTTP/1.1 200  - OK", output
    # for graphql call
    assert_match "\"name\": \"Europe\"", output
    assert_match "2 requests processed (2 succeeded, 0 failed)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end