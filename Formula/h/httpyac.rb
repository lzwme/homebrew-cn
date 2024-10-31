class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.16.3.tgz"
  sha256 "ebb0cd3602a4488c8f0e8290ac00bd5646dd2a0158d7061f5791f07050d3ed53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baeccb8ae345e272c0d330bc2517e3577350b95995f9c3e9bf703a57f509c2e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baeccb8ae345e272c0d330bc2517e3577350b95995f9c3e9bf703a57f509c2e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "baeccb8ae345e272c0d330bc2517e3577350b95995f9c3e9bf703a57f509c2e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ebcc4d9df6486ef85f93bfac8c85047b5795535d266574080569dc146c810ec"
    sha256 cellar: :any_skip_relocation, ventura:       "4ebcc4d9df6486ef85f93bfac8c85047b5795535d266574080569dc146c810ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1c1bde93c07dff5e1ab5e4dfc4746007650fea79aca76123f428c5d68fb4ef4"
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