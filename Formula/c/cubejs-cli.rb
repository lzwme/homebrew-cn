class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.10.tgz"
  sha256 "ff9d629950a01989135aefcf93026fc270693d01bb100b8b7ece8560181eebfd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f2bf7ae9e57a9a1525eb297680dcddccaec9c75d14183e2d88b5bcd203f3d40"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f2bf7ae9e57a9a1525eb297680dcddccaec9c75d14183e2d88b5bcd203f3d40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f2bf7ae9e57a9a1525eb297680dcddccaec9c75d14183e2d88b5bcd203f3d40"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8868fc7455db74755c7e97c6704fb572eab3ccd2cf0cb6094b02a7b4c0bbb17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8868fc7455db74755c7e97c6704fb572eab3ccd2cf0cb6094b02a7b4c0bbb17e"
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