class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.4.tgz"
  sha256 "cab2546cc4685cd9140c14de67eebf83505905aa8d04236c7f15a1b3012ccb74"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fa7099b6639d9f48fae1224eae0f70e559180913c7802e84642e71e58bbadb00"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa7099b6639d9f48fae1224eae0f70e559180913c7802e84642e71e58bbadb00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa7099b6639d9f48fae1224eae0f70e559180913c7802e84642e71e58bbadb00"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5ac0ec0f2283b0051dedcbc3207be9162f2912bfe9b0743e6a6c2a7e1031bbce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5ac0ec0f2283b0051dedcbc3207be9162f2912bfe9b0743e6a6c2a7e1031bbce"
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