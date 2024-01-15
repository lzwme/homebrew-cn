require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.11.1.tgz"
  sha256 "a7bb0db094850ba0c8fb1af2f848c95c6bec327dd28e45162e70e24df977e44b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24bc0b660d99247613c0490db7293bc4abcf4f107fff2b1ff6f13aa133c12990"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24bc0b660d99247613c0490db7293bc4abcf4f107fff2b1ff6f13aa133c12990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24bc0b660d99247613c0490db7293bc4abcf4f107fff2b1ff6f13aa133c12990"
    sha256 cellar: :any_skip_relocation, sonoma:         "55a98196e351cb2a869f82d7dc65a2e5cb8c41c7224099a7d89e277b23909353"
    sha256 cellar: :any_skip_relocation, ventura:        "55a98196e351cb2a869f82d7dc65a2e5cb8c41c7224099a7d89e277b23909353"
    sha256 cellar: :any_skip_relocation, monterey:       "55a98196e351cb2a869f82d7dc65a2e5cb8c41c7224099a7d89e277b23909353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "061e47bb55d7b2cae62322e398e940edf32de5d102371223ca3b6baf7d771ccf"
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