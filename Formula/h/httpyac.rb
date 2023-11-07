require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.9.3.tgz"
  sha256 "9849e35c2fa334dc1d54853099cfdb273b0af2852317a62ff891f77aa5664245"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c58c4d856ffa81995ff2e6f219a429f75be4c781856d572f6f36efc794601f63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c58c4d856ffa81995ff2e6f219a429f75be4c781856d572f6f36efc794601f63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c58c4d856ffa81995ff2e6f219a429f75be4c781856d572f6f36efc794601f63"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b68df4125832ca3b6459c073b059a01e0ee356b88fa9c8e1534501a3ae51869"
    sha256 cellar: :any_skip_relocation, ventura:        "0b68df4125832ca3b6459c073b059a01e0ee356b88fa9c8e1534501a3ae51869"
    sha256 cellar: :any_skip_relocation, monterey:       "0b68df4125832ca3b6459c073b059a01e0ee356b88fa9c8e1534501a3ae51869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4da9256e16f5254742fe24600d05ec8a4ee9d825c4ebc14ddf57c24eeff95e9"
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