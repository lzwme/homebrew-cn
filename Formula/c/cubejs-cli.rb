class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.13.tgz"
  sha256 "d919394781ebeaebbf106c01ffe2b1cb9fc8c589133400f2c7773fdeb05dd856"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fbed61e6a80d3eda5937d852630c329f957df3ba1c763e5d824449a6a858bb8c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fbed61e6a80d3eda5937d852630c329f957df3ba1c763e5d824449a6a858bb8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fbed61e6a80d3eda5937d852630c329f957df3ba1c763e5d824449a6a858bb8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ef096d07537a7ba80e6863363550936a9e53c24227857891d3ad08e6bb5baebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ef096d07537a7ba80e6863363550936a9e53c24227857891d3ad08e6bb5baebe"
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