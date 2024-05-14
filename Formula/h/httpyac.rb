require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.13.3.tgz"
  sha256 "ea9f0093e14cfcc5905cc47cc42ce3ac72c1c1914491cb50ba0fbc1feda95410"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "add8faba0bb487f090690e800da11bd3f2f0ac709b5b2a700ee876a5710c1b91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23ea8eee0a013dfda61220c5c3f3b6f688fdddbb4bbaa32e9450260d775217ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15e06986997e01ffbf5a8f264978f90350837610a1e752bc5d96eb7fdcb4b7eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "734cedd1b0d7661bda6ce4015e478125554e85f75d7814463405d7326ee66c2d"
    sha256 cellar: :any_skip_relocation, ventura:        "43842499c339b3d6fd72b3933bc3463e24191c9bf07f4a7b92ab3b8608efcdd0"
    sha256 cellar: :any_skip_relocation, monterey:       "6c191ae9edbfc07f60b1cbdfafddba98817563fb0dc16c52ab05a3ad2130a3e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "909312d8dd56b6399b4ed61ff3356b4461f51b317430ceb48e4aa21919f6db03"
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