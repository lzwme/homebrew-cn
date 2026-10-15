class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.6.tgz"
  sha256 "9a508d40fb4214dee885d22083fac7a8a493b99020989b0dbd022cb654739a90"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "379733718e25b1868eae853006b6e5de2b5cb11666a0e0bc4442195ac6624506"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "379733718e25b1868eae853006b6e5de2b5cb11666a0e0bc4442195ac6624506"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "379733718e25b1868eae853006b6e5de2b5cb11666a0e0bc4442195ac6624506"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9ec2b18f8217a452e17d34509a016ae23dfe4bc0c694d87a78fbaa2a04dc0344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9ec2b18f8217a452e17d34509a016ae23dfe4bc0c694d87a78fbaa2a04dc0344"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    ENV["CI"] = "1" # Disable telemetry.
    token = "eyJhbGciOiJub25lIn0.eyJ1cmwiOiJodHRwczovL2V4YW1wbGUuY29tIn0."
    assert_match "Token successfully added!", shell_output("#{bin}/cubejs auth #{token}")
    config = JSON.parse((testpath/".cubecloud/config.json").read)
    assert_equal token, config.dig("auth", "https://example.com", "auth")
  end
end