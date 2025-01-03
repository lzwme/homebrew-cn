class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.14.0.tgz"
  sha256 "2a017b6c869ee4d8245cb2986c1fd879c179aa3558b1d9710e7376c30489ff6f"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fbebd2132f9370f34f451660707f8f6ede4ea55bd936d30c59b914977493673f"
    sha256 cellar: :any,                 arm64_sonoma:  "fbebd2132f9370f34f451660707f8f6ede4ea55bd936d30c59b914977493673f"
    sha256 cellar: :any,                 arm64_ventura: "fbebd2132f9370f34f451660707f8f6ede4ea55bd936d30c59b914977493673f"
    sha256                               sonoma:        "1d4f0230c341f4165b71626018642a259a3baeac54064bc3adf2fd4cfe623830"
    sha256                               ventura:       "1d4f0230c341f4165b71626018642a259a3baeac54064bc3adf2fd4cfe623830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5d669a773da96a54484dcba10a97bffcf08330b399223de9d89ccf8c5b80c08"
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