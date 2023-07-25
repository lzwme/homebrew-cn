require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.6.1.tgz"
  sha256 "abc19107c9da5bd9f0a2f8f22ebe220f9250b010425d742c2dbbd7093d80cbce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96962a7cbde874be2a8e117dbdc427a97e3b7b02fa7998dea26c9203ca34307b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96962a7cbde874be2a8e117dbdc427a97e3b7b02fa7998dea26c9203ca34307b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96962a7cbde874be2a8e117dbdc427a97e3b7b02fa7998dea26c9203ca34307b"
    sha256 cellar: :any_skip_relocation, ventura:        "5339db5d86f829f0f71dc93a8718ca71a33b8bf4e7552e904cd9caaf880ef074"
    sha256 cellar: :any_skip_relocation, monterey:       "5339db5d86f829f0f71dc93a8718ca71a33b8bf4e7552e904cd9caaf880ef074"
    sha256 cellar: :any_skip_relocation, big_sur:        "5339db5d86f829f0f71dc93a8718ca71a33b8bf4e7552e904cd9caaf880ef074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "000513c8cd174af719e33a9b63259cc6812d9fd241155f31ee365238ca717fb9"
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