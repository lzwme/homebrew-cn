require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.6.0.tgz"
  sha256 "520cefd816b70af70cfdd84ae3b3a8ab2ccadb03effcd854427c3e8a30f89a8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f7653ea282bcc43c62f8e4da570bef95adb0f686911c6b6d62cf904ae95e3d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f7653ea282bcc43c62f8e4da570bef95adb0f686911c6b6d62cf904ae95e3d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f7653ea282bcc43c62f8e4da570bef95adb0f686911c6b6d62cf904ae95e3d8"
    sha256 cellar: :any_skip_relocation, ventura:        "f8589ba7afab4bb4cdfc3beadb1fa069328f354f7803ef0c9ce345d4b9ba328f"
    sha256 cellar: :any_skip_relocation, monterey:       "f8589ba7afab4bb4cdfc3beadb1fa069328f354f7803ef0c9ce345d4b9ba328f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8589ba7afab4bb4cdfc3beadb1fa069328f354f7803ef0c9ce345d4b9ba328f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0d25d176d1bc7199185a41362f8c5689b91436bafe4b9a1aec79002f0ac5439"
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