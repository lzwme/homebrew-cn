class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.14.tgz"
  sha256 "1f296eeb164aa88439dec249076c5b8ece9485139a2991f13f81e9a52e5401ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d281d6ba3642dcca37e49dd390a5517143d6568c371630e5ed748e5afaea2bc8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d281d6ba3642dcca37e49dd390a5517143d6568c371630e5ed748e5afaea2bc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d281d6ba3642dcca37e49dd390a5517143d6568c371630e5ed748e5afaea2bc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f9bd0230f9c6aca3b8f59298153d77b088e43b0ae7fbc554cfff1784073518b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f9bd0230f9c6aca3b8f59298153d77b088e43b0ae7fbc554cfff1784073518b2"
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