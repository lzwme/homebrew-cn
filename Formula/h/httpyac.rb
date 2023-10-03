require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.7.0.tgz"
  sha256 "e9d118e18a89f4ef7540a5ae3278ff6fd297b1cf23ef6ec5e7390c09947d502e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56c993d6a5568dafb8a641f3220f923f2fcabf139d77f0fb03f0f06a8f050b31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56c993d6a5568dafb8a641f3220f923f2fcabf139d77f0fb03f0f06a8f050b31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56c993d6a5568dafb8a641f3220f923f2fcabf139d77f0fb03f0f06a8f050b31"
    sha256 cellar: :any_skip_relocation, sonoma:         "cec44e45389f78c5a14d916e35ea0d2cabdf607cca4fd1d58fc99fbc695b03c1"
    sha256 cellar: :any_skip_relocation, ventura:        "cec44e45389f78c5a14d916e35ea0d2cabdf607cca4fd1d58fc99fbc695b03c1"
    sha256 cellar: :any_skip_relocation, monterey:       "cec44e45389f78c5a14d916e35ea0d2cabdf607cca4fd1d58fc99fbc695b03c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68b9e044913dcbef50b4441534030b566131c2a0420802c688cde72cb8f9384a"
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