class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.11.0.tgz"
  sha256 "27fde7f6717b5a93d1368f71fb79e139fc9db70a2d1e61738be4a9945e2e4fa8"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bc3f4d07eb8f975c00f0e65138e47129ba7213b0ae754e51383bb4056e7fb350"
    sha256 cellar: :any, arm64_tahoe:       "bc3f4d07eb8f975c00f0e65138e47129ba7213b0ae754e51383bb4056e7fb350"
    sha256 cellar: :any, arm64_sequoia:     "bc3f4d07eb8f975c00f0e65138e47129ba7213b0ae754e51383bb4056e7fb350"
    sha256 cellar: :any, arm64_linux:       "a5a9d8973463188b1bd5031b579f1a2140d9f309d38d4acea901c716d616a9a0"
    sha256 cellar: :any, x86_64_linux:      "6c8b5f6f8358cd5463e058f768077dec67a02c55adc1238bda5a9ca61be5225e"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/heroku/node_modules"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end