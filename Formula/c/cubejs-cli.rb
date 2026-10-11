class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.3.tgz"
  sha256 "7c4db49fd85e07c054769c1f0509bef7292264030abece07e22d22e092581fcf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f597b2f88696722ae8e6708167be35ec303b3c1aa31532d61e8676475c2b0dee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f597b2f88696722ae8e6708167be35ec303b3c1aa31532d61e8676475c2b0dee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f597b2f88696722ae8e6708167be35ec303b3c1aa31532d61e8676475c2b0dee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1cca55a3c81eaf535caac49966e6c8c58dce9ec0836a68b476986633df36cab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1cca55a3c81eaf535caac49966e6c8c58dce9ec0836a68b476986633df36cab5"
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