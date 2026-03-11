class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.32.0.tgz"
  sha256 "eee6cf3e2ce93388adf3c5772b4c3af3548d93d29ee04ff3f1b6923d07c02a7f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5c23d357021b5eef778aee4a0ccdeda6862f6aa2e4d62258862869f567d37ac"
    sha256 cellar: :any,                 arm64_sequoia: "369a494cf557496ecc22d3f4069dc713b439c313666e555c8868782534a5ad2f"
    sha256 cellar: :any,                 arm64_sonoma:  "369a494cf557496ecc22d3f4069dc713b439c313666e555c8868782534a5ad2f"
    sha256 cellar: :any,                 sonoma:        "93de841426d3722ad3ad820ce2fe71f1a3abd51736fe5c781de62bb675f1e394"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df21fc9e044bd36953c59fc460371d20685c3774842975dbc5950c6fb2fa5c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df21fc9e044bd36953c59fc460371d20685c3774842975dbc5950c6fb2fa5c25"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
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