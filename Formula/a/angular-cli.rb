class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.0.6.tgz"
  sha256 "60f5f3291ae123ee8d5a708f4289e7c3cdcf32882ecb8ef4188d6b29ca69018c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84ea3de5c5784daedcf35a92f4641c661f3a683f9e8c40c0b32464952a7d88b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84ea3de5c5784daedcf35a92f4641c661f3a683f9e8c40c0b32464952a7d88b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84ea3de5c5784daedcf35a92f4641c661f3a683f9e8c40c0b32464952a7d88b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8918bdafde8435d4537c5be62ad2cd540bfc65dc33ec4078b0af5d01859a7bbe"
    sha256 cellar: :any_skip_relocation, ventura:       "8918bdafde8435d4537c5be62ad2cd540bfc65dc33ec4078b0af5d01859a7bbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84ea3de5c5784daedcf35a92f4641c661f3a683f9e8c40c0b32464952a7d88b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ea3de5c5784daedcf35a92f4641c661f3a683f9e8c40c0b32464952a7d88b9"
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