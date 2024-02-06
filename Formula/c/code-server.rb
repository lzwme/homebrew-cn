require "languagenode"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.21.0.tgz"
  sha256 "9070d5e3f4cee9356f7376798de8c802549ec66d7638d27b78b4c26c23b278f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11584bb9f1d9344c6f83bc88b224fe59afba91880da2690e7a9e184017e2cb0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33ad425b3a14aa6ddb359bb7bf62f2416d3751b88865fc3b9688806961b7860c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a6e3ee86710efe20ca7479089960e8c7b9317a3545e3cf5d5b071458c852bd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "58d38829d44b340cb2938539dae2c8c06b5055412449bac70435dcdf7593a223"
    sha256 cellar: :any_skip_relocation, ventura:        "c74cd490f72ea6de35a05f0af33be0e95d729df2224a86a580ff100c9fcd739d"
    sha256 cellar: :any_skip_relocation, monterey:       "9beb7c81b150694ffb784ccb949e364d34032f887790e67f070d3d66b88c55c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af565bd851cb999db70562af4c13b980f2d3363030e547d56632f469920e7665"
  end

  depends_on "yarn" => :build
  depends_on "node@18"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    node = Formula["node@18"]
    system "npm", "install", *Language::Node.local_npm_install_args, "--unsafe-perm", "--omit", "dev"

    # @parcelwatcher bundles all binaries for other platforms & architectures
    # This deletes the non-matching architecture otherwise brew audit will complain.
    arch_string = (Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s)
    prebuilds = buildpath"libvscodenode_modules@parcelwatcherprebuilds"
    # Homebrew only supports glibc-based Linuxes, avoid missing linkage to musl libc
    (prebuilds"linux-x64node.napi.musl.node").unlink
    current_prebuild = prebuilds"#{OS.kernel_name.downcase}-#{arch_string}"
    unneeded_prebuilds = prebuilds.glob("*") - [current_prebuild]
    unneeded_prebuilds.map(&:rmtree)

    libexec.install Dir["*"]
    env = { PATH: "#{node.opt_bin}:$PATH" }
    (bin"code-server").write_env_script "#{libexec}outnodeentry.js", env
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
    assert_match "wesbos.theme-cobalt2",
      shell_output("#{bin}code-server --extensions-dir=. --list-extensions")
  end
end