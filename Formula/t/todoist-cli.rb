class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.76.0.tgz"
  sha256 "df4e5242ddf66b4a617f21121f8ce185db1df2fa530f6a75352f091bda7a323e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44dc8d41a8d6cf3738dbe87d1c9ef65212a63960f8bb47fa8ad3aecfa26e6c31"
    sha256 cellar: :any,                 arm64_sequoia: "2a00165a5f163d1aaefb8aa84b98d5a8334f4674b3b5fd8d56c99364db831fa9"
    sha256 cellar: :any,                 arm64_sonoma:  "2a00165a5f163d1aaefb8aa84b98d5a8334f4674b3b5fd8d56c99364db831fa9"
    sha256 cellar: :any,                 sonoma:        "4217e1e1429051f87cb4224043b9f89c1dcc843fa6491202a7f01f6027e15273"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "384d90da283032d053b827b230512daaafe44b45bdc0fb882eff51821eae429d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2330ed3d9e8878a7b55d6e3815a2899f18011ec884ef76a7f241cfff0555d5b"
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