class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.16.2.tgz"
  sha256 "6c183c3245b61bcdd46666231b83852be7979c539d3ba2feed4f9fcc60c79462"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7a0ea3fc665f3780f75761bbfa3588f8b2f58514f82349d536125a2a2d06bd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7a0ea3fc665f3780f75761bbfa3588f8b2f58514f82349d536125a2a2d06bd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7a0ea3fc665f3780f75761bbfa3588f8b2f58514f82349d536125a2a2d06bd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "514c8a3b436eede4c40a371352c26c5fda5add5c32c8b3156df8f9529e8f01a8"
    sha256 cellar: :any_skip_relocation, ventura:       "514c8a3b436eede4c40a371352c26c5fda5add5c32c8b3156df8f9529e8f01a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "304dbe3acda7ff26f43c3ae94e0e8558347bab7481acf9e07745060139c560f5"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
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
    assert_match "2 requests processed (2 succeeded)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end