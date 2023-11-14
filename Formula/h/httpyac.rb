require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.10.0.tgz"
  sha256 "7ea87ddb453e20b07a85173ee06644a9cb2f009ca1859e2cf8d9403e66c12d5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "babf518c0cfe977f515b4495c2417590529b4355ba42932067994b54ce615935"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "babf518c0cfe977f515b4495c2417590529b4355ba42932067994b54ce615935"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "babf518c0cfe977f515b4495c2417590529b4355ba42932067994b54ce615935"
    sha256 cellar: :any_skip_relocation, sonoma:         "57cec5734e0fc17ddbb13121575670f5e0b9c1c6ac7ffe5ff31b1bb1d9d0c0de"
    sha256 cellar: :any_skip_relocation, ventura:        "57cec5734e0fc17ddbb13121575670f5e0b9c1c6ac7ffe5ff31b1bb1d9d0c0de"
    sha256 cellar: :any_skip_relocation, monterey:       "57cec5734e0fc17ddbb13121575670f5e0b9c1c6ac7ffe5ff31b1bb1d9d0c0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b73205a42c035ce17b8b45325a2ee92e636e87e685aae27e7a13f94b84c55df"
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