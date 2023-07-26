require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.6.2.tgz"
  sha256 "c28fbe2ea9050b6e6f684993af7192067cc9ad184b6a116efc46c9c89be4e84e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9374d47b71d07cdec935e5a468431addc7dd1a62d2aac2d8ce955a28b57e6fc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9374d47b71d07cdec935e5a468431addc7dd1a62d2aac2d8ce955a28b57e6fc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9374d47b71d07cdec935e5a468431addc7dd1a62d2aac2d8ce955a28b57e6fc0"
    sha256 cellar: :any_skip_relocation, ventura:        "63779674d54a4d0cad18349882cc53ce7630fe6a2d630a53bc8f1c3e7e069795"
    sha256 cellar: :any_skip_relocation, monterey:       "63779674d54a4d0cad18349882cc53ce7630fe6a2d630a53bc8f1c3e7e069795"
    sha256 cellar: :any_skip_relocation, big_sur:        "63779674d54a4d0cad18349882cc53ce7630fe6a2d630a53bc8f1c3e7e069795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1c0a34b3d3cf979e0a68e46fdae10e5ce33a7f48f58663704c9228d2fb55f6c"
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