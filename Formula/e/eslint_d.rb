class EslintD < Formula
  desc "Speed up eslint to accelerate your development workflow"
  homepage "https:github.commantonieslint_d.js"
  url "https:registry.npmjs.orgeslint_d-eslint_d-14.2.2.tgz"
  sha256 "2146352364383bbf0f8935fd2460aea04a1fff96af4e26a7974fbee91ccfce51"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9d5b4d6bdbc13ac53b1667b7b247116830d9ebbe1c8454027a9ec38a43dbdbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9d5b4d6bdbc13ac53b1667b7b247116830d9ebbe1c8454027a9ec38a43dbdbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9d5b4d6bdbc13ac53b1667b7b247116830d9ebbe1c8454027a9ec38a43dbdbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1351de51120b458392426e395363ef55ed05caaa0a76a91d53ef0eebe6df851a"
    sha256 cellar: :any_skip_relocation, ventura:       "1351de51120b458392426e395363ef55ed05caaa0a76a91d53ef0eebe6df851a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9d5b4d6bdbc13ac53b1667b7b247116830d9ebbe1c8454027a9ec38a43dbdbd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  service do
    run [opt_bin"eslint_d", "start"]
    keep_alive true
    working_dir var
    log_path var"logeslint_d.log"
    error_log_path var"logeslint_d.err.log"
  end

  test do
    output = shell_output("#{bin}eslint_d status")
    assert_match "eslint_d: Not running", output

    assert_match version.to_s, shell_output("#{bin}eslint_d --version")
  end
end