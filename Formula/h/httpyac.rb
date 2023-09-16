require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.6.6.tgz"
  sha256 "e75aef06a5eae489a601c8a98221ff89d52e924cec9b52ac3898ef67d665c482"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f468449826366c5b20a8d2406bd74408c934de5c34037383a2c3f77ae4e525c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f468449826366c5b20a8d2406bd74408c934de5c34037383a2c3f77ae4e525c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f468449826366c5b20a8d2406bd74408c934de5c34037383a2c3f77ae4e525c"
    sha256 cellar: :any_skip_relocation, ventura:        "dd963f635cf40746656d4d7beb2fb56e2b162f269fc26f96fca35a99fc8c4e46"
    sha256 cellar: :any_skip_relocation, monterey:       "dd963f635cf40746656d4d7beb2fb56e2b162f269fc26f96fca35a99fc8c4e46"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd963f635cf40746656d4d7beb2fb56e2b162f269fc26f96fca35a99fc8c4e46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b617f9678be79c0bfc4d0bc51c00d805d044c090637af1906d32bd3c19980e2"
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