class EslintD < Formula
  desc "Speed up eslint to accelerate your development workflow"
  homepage "https://github.com/mantoni/eslint_d.js"
  url "https://registry.npmjs.org/eslint_d/-/eslint_d-14.3.0.tgz"
  sha256 "f873d33ca7b7851704555a6453798163956a3f525a322d3caea8c16b294933c3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c5ca189ad00f34f3cc677a15f64365ff38df837d714f06ae88ea20ff94b33a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c5ca189ad00f34f3cc677a15f64365ff38df837d714f06ae88ea20ff94b33a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c5ca189ad00f34f3cc677a15f64365ff38df837d714f06ae88ea20ff94b33a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a88cd79ce9eb0f41819ac02c88895f29018508f40dff433b477b3a079135efa"
    sha256 cellar: :any_skip_relocation, ventura:       "2a88cd79ce9eb0f41819ac02c88895f29018508f40dff433b477b3a079135efa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c5ca189ad00f34f3cc677a15f64365ff38df837d714f06ae88ea20ff94b33a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c5ca189ad00f34f3cc677a15f64365ff38df837d714f06ae88ea20ff94b33a5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  service do
    run [opt_bin/"eslint_d", "start"]
    keep_alive true
    working_dir var
    log_path var/"log/eslint_d.log"
    error_log_path var/"log/eslint_d.err.log"
  end

  test do
    output = shell_output("#{bin}/eslint_d status")
    assert_match "eslint_d: Not running", output

    assert_match version.to_s, shell_output("#{bin}/eslint_d --version")
  end
end