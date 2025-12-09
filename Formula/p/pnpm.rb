class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.25.0.tgz"
  sha256 "0f3726654b0b5e52e5800904de168afc3c667e2abf84bdb06d9ac1386104bd90"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf9a502c0da8ed527866a6f7dcd16cca3e689dc9e9399c53f86ec23070d0a8f1"
    sha256 cellar: :any,                 arm64_sequoia: "90bf38ed10b5ba0c1d879363e197a3f826dd5d139661f7ce5c88f3ec78dffdb9"
    sha256 cellar: :any,                 arm64_sonoma:  "90bf38ed10b5ba0c1d879363e197a3f826dd5d139661f7ce5c88f3ec78dffdb9"
    sha256 cellar: :any,                 sonoma:        "aa3aac81155533ee55e3029abd8b635e8b500925380fcade8c8d684b220f80a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0134597ccee16c1c0f323c377e341bd907b1b6da58456e11b21ba865a8de738a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0134597ccee16c1c0f323c377e341bd907b1b6da58456e11b21ba865a8de738a"
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