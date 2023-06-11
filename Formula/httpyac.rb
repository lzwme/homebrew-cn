require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.4.6.tgz"
  sha256 "216354497c2e1c408ad5fb124e60307f92fbb440089fcea023ceca4c251caf42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edc2ccc305346b6e1c9d478ecc1deca2382f492b31e219d05830ebc4c958f7a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edc2ccc305346b6e1c9d478ecc1deca2382f492b31e219d05830ebc4c958f7a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efd29071ccb245b786aafb40f186a5f74f52326e4df2f56e23b4b1337a3ef21c"
    sha256 cellar: :any_skip_relocation, ventura:        "fce2ef59af688a31e130e597dc41558daccb30d34577d2e1b20ef578281e0641"
    sha256 cellar: :any_skip_relocation, monterey:       "fce2ef59af688a31e130e597dc41558daccb30d34577d2e1b20ef578281e0641"
    sha256 cellar: :any_skip_relocation, big_sur:        "fce2ef59af688a31e130e597dc41558daccb30d34577d2e1b20ef578281e0641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f56c02368d83632acfc5575bda724bef872d6f44a6615ab6e092714706d2fc"
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