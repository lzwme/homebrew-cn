require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.12.1.tgz"
  sha256 "d81ba2a1e70189e2a35a5760a55493f87af316e8140d0668d419a66de572a965"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b970a97cf1bac971f924b23fe9ea411a07d44772d606a139aac7ed40e2171f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b970a97cf1bac971f924b23fe9ea411a07d44772d606a139aac7ed40e2171f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b970a97cf1bac971f924b23fe9ea411a07d44772d606a139aac7ed40e2171f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bea264d481201034f54dcfb392c16397255bba76c179d63589803850c7ba974"
    sha256 cellar: :any_skip_relocation, ventura:        "2bea264d481201034f54dcfb392c16397255bba76c179d63589803850c7ba974"
    sha256 cellar: :any_skip_relocation, monterey:       "2bea264d481201034f54dcfb392c16397255bba76c179d63589803850c7ba974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0e62274e2de525d660e97e17a08ea4c1e089773def3d3b209d0b6042110fc6c"
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