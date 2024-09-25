class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.93.1.tgz"
  sha256 "c6204fbb323f2950a42c49b88a2fc2d02b45d4cf684e88b220d9fe1fda3f9a0a"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "d60aa5731fcc2e9302b5b375269bf9064580e3b9d2c69a92e7f9a1169241e609"
    sha256                               arm64_sonoma:  "051599c8f13b38e01b6e3b8dc397135913463d046bab2cd219977ef109eb5fc3"
    sha256                               arm64_ventura: "0bfa49c4fcd3947473d3bd579fceae7f30dd2f155ec9097001f23d2c9c612b27"
    sha256                               sonoma:        "7fc1f86fa5955cd58e79e021f59a38dd61a353275c9619cba48b952d573c198c"
    sha256                               ventura:       "c5f1ed0fdd96c7c350af2ccfb0dd40796feb7867e9595330887ec67e370d7c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a4e616197dce8aa9ef656796411b952d9ed3a723663f46ecc0f0723041a002"
  end

  depends_on "node@20"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "krb5"
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    # Fix broken node-addon-api: https:github.comnodejsnodeissues52229
    ENV.append "CXXFLAGS", "-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    vscode = libexec"libnode_modulescode-serverlibvscode"
    vscode.glob("{,extensions}node_modules@parcelwatcherprebuilds*")
          .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    vscode.glob("{,extensions}node_modules@parcelwatcherprebuildslinux-x64*.musl.node")
          .map(&:unlink)
  end

  def caveats
    <<~EOS
      The launchd service runs on http:127.0.0.1:8080. Logs are located at #{var}logcode-server.log.
    EOS
  end

  service do
    run opt_bin"code-server"
    keep_alive true
    error_log_path var"logcode-server.log"
    log_path var"logcode-server.log"
    working_dir Dir.home
  end

  test do
    # See https:github.comcdrcode-serverblobmaincibuildtest-standalone-release.sh
    system bin"code-server", "--extensions-dir=.", "--install-extension", "wesbos.theme-cobalt2"
    output = shell_output("#{bin}code-server --extensions-dir=. --list-extensions")
    assert_match "wesbos.theme-cobalt2", output
  end
end