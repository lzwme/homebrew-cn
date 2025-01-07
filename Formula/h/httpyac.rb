class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.16.5.tgz"
  sha256 "63337bf1cdf48bf2975ba760bef00c0fddfdfd6caf88500b37d8658700bd5c04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "794e33223b31290cc77818384f75891b4ec6affe19c94e4040b0807b2dbc6600"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "794e33223b31290cc77818384f75891b4ec6affe19c94e4040b0807b2dbc6600"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "794e33223b31290cc77818384f75891b4ec6affe19c94e4040b0807b2dbc6600"
    sha256 cellar: :any_skip_relocation, sonoma:        "4265c4eb1a15c3e4417592bf5ad7ebefc902d5d864d6b93e04e4f32b05cf2dae"
    sha256 cellar: :any_skip_relocation, ventura:       "4265c4eb1a15c3e4417592bf5ad7ebefc902d5d864d6b93e04e4f32b05cf2dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28c0785028d21248d48989a620f4abda4a57c8d142944655e45443d06305abf1"
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