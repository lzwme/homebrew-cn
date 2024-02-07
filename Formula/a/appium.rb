require "languagenode"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.5.0.tgz"
  sha256 "7a48311789f22fab117324922b6e32ed0eed43521b265b399f236f6a743ac37e"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "391d12db5995af13b868a824bdd6bd09a3b31ef8eb22cb9bffe40273cc8589cc"
    sha256 cellar: :any,                 arm64_ventura:  "391d12db5995af13b868a824bdd6bd09a3b31ef8eb22cb9bffe40273cc8589cc"
    sha256 cellar: :any,                 arm64_monterey: "391d12db5995af13b868a824bdd6bd09a3b31ef8eb22cb9bffe40273cc8589cc"
    sha256 cellar: :any,                 sonoma:         "b3738c214fa3876f94064499fc00b616e3c9bc5dd220441bdfa8d9c5dc8ea328"
    sha256 cellar: :any,                 ventura:        "b3738c214fa3876f94064499fc00b616e3c9bc5dd220441bdfa8d9c5dc8ea328"
    sha256 cellar: :any,                 monterey:       "b3738c214fa3876f94064499fc00b616e3c9bc5dd220441bdfa8d9c5dc8ea328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b43d8d9329062fee466bbd655379e63ca9d34fb9c39c2027b349f8ce40dc298"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}bin*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    if OS.linux?
      node_modules = libexec"libnode_modulesappiumnode_modules"
      (node_modules"@imgsharp-libvips-linuxmusl-x64liblibvips-cpp.so.42").unlink
      (node_modules"@imgsharp-linuxmusl-x64libsharp-linuxmusl-x64.node").unlink
    end

    # Replace universal binaries with native slices
    deuniversalize_machos
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