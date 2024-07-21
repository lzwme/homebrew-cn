require "languagenode"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.91.1.tgz"
  sha256 "caff899580267b4020c9cde70eda1f0d465f6ee6c134177ad4334de783918ccc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34e3f851d17904af4b81e2c05ad277971f7b463691858943d6e16e22dc1bb170"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4a98a378a47037ef44fa44a12c6a07b32eff3e855836580f6556a9f6d4a74f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79a34cc4514cb1dd21e061c5aec72da9aa3ec215292781682d391e7c39787829"
    sha256 cellar: :any_skip_relocation, sonoma:         "3220d02d930f5f148bbf0f3c1be20f8bd74652de6cbe3f43ec12a5ec40662154"
    sha256 cellar: :any_skip_relocation, ventura:        "c33fd1f0626220f8f3ecf678a3d06de5b5dfd68c5135b0c46896991e02fff4af"
    sha256 cellar: :any_skip_relocation, monterey:       "7beccbb9b5e1d8f16a7a910a0a61397f30010f9ba661a8ba53667469ddd5186f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f75a1edb6fefde561f59ea5f8493e56e38e116a92c9d287620e6ebb4dfa3dbe6"
  end

  depends_on "yarn" => :build
  depends_on "node@20"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    # Fix broken node-addon-api: https:github.comnodejsnodeissues52229
    ENV.append "CXXFLAGS", "-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT"

    node = Formula["node@20"]
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