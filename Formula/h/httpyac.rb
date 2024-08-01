class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.14.0.tgz"
  sha256 "5beb938d2def06b639290493f8d975e96aa9619a7f04f6ce51e98c7c538c7402"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20f4678757bf3a502c0910fab84880187f72c73a00220d5c24c9d406ba7a128e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20f4678757bf3a502c0910fab84880187f72c73a00220d5c24c9d406ba7a128e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20f4678757bf3a502c0910fab84880187f72c73a00220d5c24c9d406ba7a128e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac605190f0251454a44387b85d3d68c6f3bc34d03ff3ce09afbd9092a72b24c6"
    sha256 cellar: :any_skip_relocation, ventura:        "ac605190f0251454a44387b85d3d68c6f3bc34d03ff3ce09afbd9092a72b24c6"
    sha256 cellar: :any_skip_relocation, monterey:       "ac605190f0251454a44387b85d3d68c6f3bc34d03ff3ce09afbd9092a72b24c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54f4110665146cf751ec7632a5672efcdeeee84670c12c63f6c424a2dacee413"
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
    assert_match "2 requests processed (2 succeeded, 0 failed)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end