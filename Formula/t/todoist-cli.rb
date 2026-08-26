class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.3.1.tgz"
  sha256 "3138b6beda0f3cc4a724a6ff4d41391535a4931c430cd5f9929adb2fdb685d43"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69684772d32615870766249184ff2691593c80b403d8346f71b04d7961e1cb1d"
    sha256 cellar: :any,                 arm64_sequoia: "69684772d32615870766249184ff2691593c80b403d8346f71b04d7961e1cb1d"
    sha256 cellar: :any,                 arm64_sonoma:  "69684772d32615870766249184ff2691593c80b403d8346f71b04d7961e1cb1d"
    sha256 cellar: :any,                 sonoma:        "8d901df5e1adc9911e0dbf940f054777aa012ef818ab1995694090e7456df3d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c0f8338011b8003f9a8925a8064e2d15d1f1f3db56d079676950ab29222daa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60a7aff21146e0b635c2b92fa833c52dc9b863e3b7305531654f8b27eb6039cd"
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