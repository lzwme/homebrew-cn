class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.0.5.tgz"
  sha256 "a0fe91e3a2976ca3f08f37582c96452b2bfba504de09f9312719aae23cbfc54a"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f959bf2919c623ef941cb9dee8d8b8ff10fefe8e2ed75d49b0ccb28a2d976132"
    sha256 cellar: :any,                 arm64_sequoia: "b20ed192e02cbbd48599d12d7cd95ed92d373d867ce9968ae430e392935581de"
    sha256 cellar: :any,                 arm64_sonoma:  "b20ed192e02cbbd48599d12d7cd95ed92d373d867ce9968ae430e392935581de"
    sha256 cellar: :any,                 sonoma:        "234eae5872456d7ee9efea47e3f0c6c575e7811ddb4cbd5e3154658067aa6d19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67ff9dbc54be3389ed661e321953de24bbf64ac293cd1aadb3788c401227ee34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67ff9dbc54be3389ed661e321953de24bbf64ac293cd1aadb3788c401227ee34"
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