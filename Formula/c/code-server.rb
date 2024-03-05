require "languagenode"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.22.0.tgz"
  sha256 "543fda5398c54354470f7d9fc2f0e681b81011dcba2574a2682f1d46921effa1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be15f5dd6ab5200a541fe1f8d9a84a65e7b0491aa1caac3c3e5d457e1d28ae39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44f743f069bc282fa947c27cdb7be9912ad4de93bab4c059e6a516ad1edb2ddc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6df26d5475677aabf69e38e1438f603d5155ae3a1eee4ba660b6f84996d6568"
    sha256 cellar: :any_skip_relocation, sonoma:         "e694e9651c3287060f6871c925b789fd2cb82a0dee47e1b282a8db5df2ad9450"
    sha256 cellar: :any_skip_relocation, ventura:        "8c9b9cf010c581fa32b4ff979a734717b7238a906b134b9d224da47f818a6bd5"
    sha256 cellar: :any_skip_relocation, monterey:       "c79b0f66b9537b2d1492c10cd93a731e9633ea9bc0c171df13b76f11051dda8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6075c7dc5ceb46f78ddd6e25e7ebff237724d91b5678b4ffd207984edf59db3"
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