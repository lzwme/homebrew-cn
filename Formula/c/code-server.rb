require "languagenode"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.20.1.tgz"
  sha256 "026c04ff810d67eeb622a7f61eef8d278267100ae3c3cf291430cd855f1f1169"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6aaa2792e9b38f4efa31949dad0440f12fea49214ee70f34fcf30d8d134bd516"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "482be0f82e98e8c92d7f7cdcaba5a3da9265fae715a694a3473279412564275a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d358a8a38e7d52c9e0e10f9fb8fdd4d0d7982465655e72bed9ef85c3afa605f"
    sha256 cellar: :any_skip_relocation, sonoma:         "41322cad743378e5765a5f5ada6a3c776edf8cc9e140e4a761833a2ba982008b"
    sha256 cellar: :any_skip_relocation, ventura:        "fca7028bb9207d5f3773861e77080496bd39ec0c1c5cec132bef6a9a51ba1114"
    sha256 cellar: :any_skip_relocation, monterey:       "6f1509e2ec325ebcc4a59f408fd843d4a18ed38d8ced38b55a8ad6d7f3e03534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e01090b76821276a5e52e02cbe5d71ee184172eb9decc8c080148b3ecd4683b"
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