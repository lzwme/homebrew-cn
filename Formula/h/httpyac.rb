class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.16.0.tgz"
  sha256 "11ed491bd4f80997c287afd0883f64b9eb599cd25c1a1a7b99d0072000171bbb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16d8c92bcb9161bae23dcf8d40eb46908bd8ed0694e62809682737bbddf41bcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16d8c92bcb9161bae23dcf8d40eb46908bd8ed0694e62809682737bbddf41bcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16d8c92bcb9161bae23dcf8d40eb46908bd8ed0694e62809682737bbddf41bcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1f99801c1caf604b9844c7f2ef1c467aec69adec5f1f15bffb2672b92b044ec"
    sha256 cellar: :any_skip_relocation, ventura:       "a1f99801c1caf604b9844c7f2ef1c467aec69adec5f1f15bffb2672b92b044ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50989acd8ac71612f33cbd20d48bae59964537f9db635d0c3a12b1fd18cc55ba"
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