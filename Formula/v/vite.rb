class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.4.tgz"
  sha256 "b2385f966f345223d894a34aca9ab46ce0764a34d80d00f2ac81abe3fa0516e8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0ef003d64883724601bce19aed85bae2a2939c15cfe7701bf1aa0db30ea6e117"
    sha256 cellar: :any,                 arm64_sonoma:   "0ef003d64883724601bce19aed85bae2a2939c15cfe7701bf1aa0db30ea6e117"
    sha256 cellar: :any,                 arm64_ventura:  "0ef003d64883724601bce19aed85bae2a2939c15cfe7701bf1aa0db30ea6e117"
    sha256 cellar: :any,                 arm64_monterey: "0ef003d64883724601bce19aed85bae2a2939c15cfe7701bf1aa0db30ea6e117"
    sha256 cellar: :any,                 sonoma:         "551a80345c1c8e6b523094772a4c604586384ed4589f4691f8854dac7e555c1f"
    sha256 cellar: :any,                 ventura:        "551a80345c1c8e6b523094772a4c604586384ed4589f4691f8854dac7e555c1f"
    sha256 cellar: :any,                 monterey:       "551a80345c1c8e6b523094772a4c604586384ed4589f4691f8854dac7e555c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d897d97e93714d1c866e467251aac5615593e51d5351cceb157a804d7162038"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end