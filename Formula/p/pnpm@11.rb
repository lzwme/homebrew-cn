class PnpmAT11 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.26.0.tgz"
  sha256 "c332207e738f84b7ccf95d5f21f6fdf10b0dc5b133f0a349834a26fd17abacd8"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "67d8d48f46b87113500eb4a3c169886013e825c7e2eaae8fe9b36d85812df6c9"
    sha256 cellar: :any,                 arm64_tahoe:       "67d8d48f46b87113500eb4a3c169886013e825c7e2eaae8fe9b36d85812df6c9"
    sha256 cellar: :any,                 arm64_sequoia:     "67d8d48f46b87113500eb4a3c169886013e825c7e2eaae8fe9b36d85812df6c9"
    sha256 cellar: :any,                 arm64_sonoma:      "67d8d48f46b87113500eb4a3c169886013e825c7e2eaae8fe9b36d85812df6c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8fbcb34b2259570171541e8a4d9decd66dad16ecf935d5fca1f6bedcedb89c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8fbcb34b2259570171541e8a4d9decd66dad16ecf935d5fca1f6bedcedb89c62"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  # downloads npm packages during install
  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@11"
    bin.install_symlink bin/"pnpx" => "pnpx@11"

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