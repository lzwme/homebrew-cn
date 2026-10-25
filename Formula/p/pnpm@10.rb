class PnpmAT10 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.34.8.tgz"
  sha256 "5be9fac9764583af5fa07015b9b0aa930ef634535df9fa6f464020d72b195630"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "65959a99eb08df81aa16d960e00cb18e5bd5984602b7ed6b70ee7b976d81eda0"
    sha256 cellar: :any,                 arm64_tahoe:       "65959a99eb08df81aa16d960e00cb18e5bd5984602b7ed6b70ee7b976d81eda0"
    sha256 cellar: :any,                 arm64_sequoia:     "65959a99eb08df81aa16d960e00cb18e5bd5984602b7ed6b70ee7b976d81eda0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5ab7f3ecbf9ed576659deeec12ffc537fd18f91efbeaf5ba2990a05f1999fc8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5ab7f3ecbf9ed576659deeec12ffc537fd18f91efbeaf5ba2990a05f1999fc8d"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@10"
    bin.install_symlink bin/"pnpx" => "pnpx@10"

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