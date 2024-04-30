require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.13.1.tgz"
  sha256 "6f36990c7a38a7e4e55ceb831a69ba86a4aa22415c20f6f096dede008b9fff54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "290fd523cd218527dd9d18b2fb8c06b956e9681cfbaf8fef1c67807e17d3cbbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "290fd523cd218527dd9d18b2fb8c06b956e9681cfbaf8fef1c67807e17d3cbbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "290fd523cd218527dd9d18b2fb8c06b956e9681cfbaf8fef1c67807e17d3cbbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "78ca92e1af3a101f878581b72c15b5b51e407c84ba9f95044855ec57da546061"
    sha256 cellar: :any_skip_relocation, ventura:        "78ca92e1af3a101f878581b72c15b5b51e407c84ba9f95044855ec57da546061"
    sha256 cellar: :any_skip_relocation, monterey:       "78ca92e1af3a101f878581b72c15b5b51e407c84ba9f95044855ec57da546061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70b5435bb67a5376be12a3025090b9a205a18d7f720c5affe4a2838abdbaef52"
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