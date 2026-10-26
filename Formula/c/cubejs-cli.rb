class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.11.tgz"
  sha256 "f2a12f5d28c6a78ff756e76135113bb4b3ea49b9d5e3d45f2b4594fa05c9e7c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d27c2792019ba9280746fd04aecf3d429cc72aa94db3c3e83670fbaa3a55f23"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d27c2792019ba9280746fd04aecf3d429cc72aa94db3c3e83670fbaa3a55f23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d27c2792019ba9280746fd04aecf3d429cc72aa94db3c3e83670fbaa3a55f23"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2cede4db7b7d64ed9be7f65bd22675f000b694c2e679694519967e8702d2250f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2cede4db7b7d64ed9be7f65bd22675f000b694c2e679694519967e8702d2250f"
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