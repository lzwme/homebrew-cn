require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.4.1.tgz"
  sha256 "65531758abe5f73cdb57fdf459dbf20dfe58da880888bbc16648c75d53cf6052"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6e40c48f8af2c687b354c89c1ffcd015cf2469b320dc2b5152fd1ac5ab60667"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6e40c48f8af2c687b354c89c1ffcd015cf2469b320dc2b5152fd1ac5ab60667"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6e40c48f8af2c687b354c89c1ffcd015cf2469b320dc2b5152fd1ac5ab60667"
    sha256 cellar: :any_skip_relocation, ventura:        "9d0f6f527cb06ec74d5862f9fca8ef85b87124e56bdc578583f76a3867afd0b1"
    sha256 cellar: :any_skip_relocation, monterey:       "9d0f6f527cb06ec74d5862f9fca8ef85b87124e56bdc578583f76a3867afd0b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d0f6f527cb06ec74d5862f9fca8ef85b87124e56bdc578583f76a3867afd0b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d7c805cf081edb64578529af0562075cfaba88064c3b5c8a99dc506ed730565"
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