class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-2.1.0.tgz"
  sha256 "e9ea307cb14c05f667a993b7aa2b64e0f0b0e6ed8f3ed1bf20bcf09f38e97752"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93ad5ac99e58ba130d50de932edc7c1546bf0a03999609fd003081b707bacdd8"
    sha256 cellar: :any,                 arm64_sequoia: "93ad5ac99e58ba130d50de932edc7c1546bf0a03999609fd003081b707bacdd8"
    sha256 cellar: :any,                 arm64_sonoma:  "93ad5ac99e58ba130d50de932edc7c1546bf0a03999609fd003081b707bacdd8"
    sha256 cellar: :any,                 sonoma:        "a5ad3570dae941bd16cb36b8569226cd8a8c56dd43184ad7d6a997c4fc0626bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78b5c3a98a01dc550be7304852402ad88aedb1650a02e022e8a625af85cdc608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ba4787cf6a81ec5be2193c4f8a5a0739ca68c47e2643e56a5928b2b9d21f80"
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