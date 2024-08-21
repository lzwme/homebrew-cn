class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.92.2.tgz"
  sha256 "e6a18f3cd4ad53878a221c2391cabc51602b06202d1b8ae356a3cb0416f164b8"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "9db9ee85af6fcac6bac2733f6d1304611fe5677baa7ae3f04aa3c97d162f3bc8"
    sha256                               arm64_ventura:  "ae4315c03c8d66f168dcbd562fe327521a9dded9a6527b660ee338b33b266395"
    sha256                               arm64_monterey: "216362c79e6bad1f27f6619b23a59ef8aa620fda3d9ba71d1ee7cc92951ca5e6"
    sha256                               sonoma:         "0a0eb392447e4ebef237a9db662f640023e9427004006e4c4818e176c250849e"
    sha256                               ventura:        "2dc334adccf45d1714a11e558ba2657395159b5005f0335e39dcb0eea172e672"
    sha256                               monterey:       "54b957fe04157668dce0c10cedb5d57908d091e1841aa5b8a97ce812492a6d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22535e120c7236b8edfa1d926af22597ec6c82c097b9d3d7df1b865f5f9a6e6b"
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