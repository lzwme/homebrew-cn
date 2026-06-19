class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.8.0.tgz"
  sha256 "1e963a5c4ca5168550ba03fc4ee8d873a772b072b7fce63b48fff27d720e2e98"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "788bfa23d74e97eb851e9cfe3a35dd899c3d8ccd5a9e40fce07d915718ec196f"
    sha256 cellar: :any,                 arm64_sequoia: "105c0e624086f42eff175cee39b51c9fc9cdb959d81e9edfe799b7a5cb0c606c"
    sha256 cellar: :any,                 arm64_sonoma:  "105c0e624086f42eff175cee39b51c9fc9cdb959d81e9edfe799b7a5cb0c606c"
    sha256 cellar: :any,                 sonoma:        "229c2767caef8b2bcd0f807971db1365c29149790e247445ba78b5b0282ff29b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdb422a135f7415bf4e29544e294cad34813cff6cd886e144db9b593b0d6bce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdb422a135f7415bf4e29544e294cad34813cff6cd886e144db9b593b0d6bce7"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("**/reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end