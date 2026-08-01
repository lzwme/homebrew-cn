class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.1.0.tgz"
  sha256 "d2ebb913ed2425cee22f60b0aace2ca6e3cfea7fb80ac38993cfc978f21efe34"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0709a2988d793bb19ff19a1c4bc2e8c98d2cda44be7804396e51f107021518bc"
    sha256 cellar: :any,                 arm64_sequoia: "0709a2988d793bb19ff19a1c4bc2e8c98d2cda44be7804396e51f107021518bc"
    sha256 cellar: :any,                 arm64_sonoma:  "0709a2988d793bb19ff19a1c4bc2e8c98d2cda44be7804396e51f107021518bc"
    sha256 cellar: :any,                 sonoma:        "17c60befc3a82076e3d50daf5c30ec24bbc442aa20bef1907efdff757f197188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "302fdb0031b69125fa3f2bbf21ee62b9a997f6ca7d144ae6836d2245cda90aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5876e235b2ed3e71f0feb3f98cb47797a8a516255b901e6da2605d9479239db"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end