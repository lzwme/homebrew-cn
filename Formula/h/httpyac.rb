require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.11.2.tgz"
  sha256 "c31e85055001927ed43ab52c6f44ae349c6f922143ac885ffc370093fb849068"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47357e0c88cdf560aa9a27a07d9a4f797cd1836fbaf1858448061b9b2667ddfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47357e0c88cdf560aa9a27a07d9a4f797cd1836fbaf1858448061b9b2667ddfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47357e0c88cdf560aa9a27a07d9a4f797cd1836fbaf1858448061b9b2667ddfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e1d8a6646da37830ccd8c96f9599969b5dda64bbad3a172e5e2843f63825f7f"
    sha256 cellar: :any_skip_relocation, ventura:        "2e1d8a6646da37830ccd8c96f9599969b5dda64bbad3a172e5e2843f63825f7f"
    sha256 cellar: :any_skip_relocation, monterey:       "2e1d8a6646da37830ccd8c96f9599969b5dda64bbad3a172e5e2843f63825f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95864112cb99659c192476c38cf19efc516ac9f5975d3daed5bd2d0ece3de4f3"
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