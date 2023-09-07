require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.6.5.tgz"
  sha256 "286213c95e71b25e99311e2c21bda9802e0ffe4be12f975f4ceb4fc60ad19081"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca0de7a955ee8f2965086a1454cef3660fc1d8d4f15bcf690b5d55c2543cf7eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca0de7a955ee8f2965086a1454cef3660fc1d8d4f15bcf690b5d55c2543cf7eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca0de7a955ee8f2965086a1454cef3660fc1d8d4f15bcf690b5d55c2543cf7eb"
    sha256 cellar: :any_skip_relocation, ventura:        "086b02b94b7f6a89abb9b9a65126ae151412f13cd25d3b33e45abca4723c871a"
    sha256 cellar: :any_skip_relocation, monterey:       "086b02b94b7f6a89abb9b9a65126ae151412f13cd25d3b33e45abca4723c871a"
    sha256 cellar: :any_skip_relocation, big_sur:        "086b02b94b7f6a89abb9b9a65126ae151412f13cd25d3b33e45abca4723c871a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5988c2c00bb6115bcf54edf69639c75178bc3868cf8349fdb525f15fed073220"
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