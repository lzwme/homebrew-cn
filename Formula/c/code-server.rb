require "languagenode"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.19.1.tgz"
  sha256 "e2b6e781a006dd5233c82bfa3f6b0dfb8c7fb48c0c2dd5b415a79f6185b8850f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30c263f70cef48c619d823be18d67a84c61d578244106e5ebc39476255c6bd0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f2d3f67f9e6272f3aa0286be15e780a428f242e4d3154e8899dcbe90740bcd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea5eceabea3a5989e42dd31cf6415febbb758e99f411bfe4ff36f2c6c267bfa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c492a9627d7355b25fc921df94b0580a583a2157b0df14494389684f18dd4ae"
    sha256 cellar: :any_skip_relocation, ventura:        "1ffa94f1a623bb9dea8358436ef9c4e2f31e7b3d73d81886269928ea9c9d7f85"
    sha256 cellar: :any_skip_relocation, monterey:       "bb2650a93ce65673071428a220131d9b498654e24f182b9805259854721d2a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe31184ac83c56abf7bac9199c8216f60d97fce784531abe10878ad5fa4165e0"
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