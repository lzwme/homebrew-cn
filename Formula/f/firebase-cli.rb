class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.31.0.tgz"
  sha256 "19cfa8fc64d3bf8e0ae99649ae2c2575ebfd50ae9238a99380abf612eacf9383"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "268decb6c06da28e2fa4088c0e8a82077ac60cd52cb73198a8a2689263efa4db"
    sha256 cellar: :any, arm64_tahoe:       "268decb6c06da28e2fa4088c0e8a82077ac60cd52cb73198a8a2689263efa4db"
    sha256 cellar: :any, arm64_sequoia:     "268decb6c06da28e2fa4088c0e8a82077ac60cd52cb73198a8a2689263efa4db"
    sha256 cellar: :any, arm64_linux:       "75899f91355224ee83df571479d659b21d7e123fac97883c2e948f05031b3e68"
    sha256 cellar: :any, x86_64_linux:      "d7ae0cbebaa1b20d645d7f59f0b45ecd1640e535db0bd69c0b16582e01b85484"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end