require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.9.1.tgz"
  sha256 "a8b223be93d0a2959986481d460a419c185444f3f6c161834ae0b753cff85fbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2eb6ef50be0b4bb2d4a71409dc223e6e134131426bddc87814dfdeb5c6926882"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2eb6ef50be0b4bb2d4a71409dc223e6e134131426bddc87814dfdeb5c6926882"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eb6ef50be0b4bb2d4a71409dc223e6e134131426bddc87814dfdeb5c6926882"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d4d1b63e94cf97ea344f9ba9f7fba5452045bdd3387bf30f32ddc849ffc8364"
    sha256 cellar: :any_skip_relocation, ventura:        "7d4d1b63e94cf97ea344f9ba9f7fba5452045bdd3387bf30f32ddc849ffc8364"
    sha256 cellar: :any_skip_relocation, monterey:       "7d4d1b63e94cf97ea344f9ba9f7fba5452045bdd3387bf30f32ddc849ffc8364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f59a75cdaf998bbfd6e3f220de597dbda6e76318e14c59fa74e890aa86770ef"
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