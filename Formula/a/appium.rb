class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.13.1.tgz"
  sha256 "96a0771bff8182cf90978dcfbf796c82521f999b53570e68aecaba1a33a60ed9"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "426e84ce1c2b8a77bd5ad9d23dd0c06775f0324c4f896ec1c8c1f5e72f6b9ce6"
    sha256 cellar: :any,                 arm64_sonoma:  "426e84ce1c2b8a77bd5ad9d23dd0c06775f0324c4f896ec1c8c1f5e72f6b9ce6"
    sha256 cellar: :any,                 arm64_ventura: "426e84ce1c2b8a77bd5ad9d23dd0c06775f0324c4f896ec1c8c1f5e72f6b9ce6"
    sha256                               sonoma:        "cf33f197c41788f7d86f55c377070686da89ecab5c9ec7963c491d6db710c416"
    sha256                               ventura:       "cf33f197c41788f7d86f55c377070686da89ecab5c9ec7963c491d6db710c416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78579f14f13514c45d1310236dac4f822dbada8a83538c41fe1e2e8ff0bd9678"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *std_npm_args, "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  service do
    run opt_bin"appium"
    environment_variables PATH: std_service_path_env
    keep_alive true
    error_log_path var"logappium-error.log"
    log_path var"logappium.log"
    working_dir var
  end

  test do
    output = shell_output("#{bin}appium server --show-build-info")
    assert_match version.to_s, JSON.parse(output)["version"]

    output = shell_output("#{bin}appium driver list 2>&1")
    assert_match "uiautomator2", output

    output = shell_output("#{bin}appium plugin list 2>&1")
    assert_match "images", output

    assert_match version.to_s, shell_output("#{bin}appium --version")
  end
end