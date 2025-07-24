class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.1.2.tgz"
  sha256 "cc835432f2ca2070f86bce74d094ed3d63d9ca1ed67b6545347696036138cb94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa36bc131fa8017806308eafd37d397279a4b3fc4dbf7257b407de0ca59b0154"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa36bc131fa8017806308eafd37d397279a4b3fc4dbf7257b407de0ca59b0154"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa36bc131fa8017806308eafd37d397279a4b3fc4dbf7257b407de0ca59b0154"
    sha256 cellar: :any_skip_relocation, sonoma:        "d71efe2ef2de3d32403aa73b4f2db3106df35aa14c5cc917d5fa943df40257a8"
    sha256 cellar: :any_skip_relocation, ventura:       "d71efe2ef2de3d32403aa73b4f2db3106df35aa14c5cc917d5fa943df40257a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa36bc131fa8017806308eafd37d397279a4b3fc4dbf7257b407de0ca59b0154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa36bc131fa8017806308eafd37d397279a4b3fc4dbf7257b407de0ca59b0154"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end