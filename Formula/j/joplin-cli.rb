class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https:joplinapp.org"
  url "https:registry.npmjs.orgjoplin-joplin-3.2.2.tgz"
  sha256 "46cda9164f1e20c2ea451fa12398532fbbeb421a9bcdf275ac220f4163f75da5"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "9fb6115ba720d86c13274d26ae70de7f41193f03b3e33d4732e369b8d7d12438"
    sha256                               arm64_sonoma:  "4f970ffbf4f5a913f15b76f3f69f991e18f557251a047ac3ab2207d7f4186a4a"
    sha256                               arm64_ventura: "a3611669daf544c463ef4ed5f7345e907d61f30cb0faa16bae76f5cc275b1254"
    sha256                               sonoma:        "e08b770b0c9c9ad238a7385286a3470c9683c2651b839172c270f100115e1e53"
    sha256                               ventura:       "116677217ea988081c9e828ef17b43938e7378fd97166d7dc678c7e476a4bac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "284ad0fcb8c24fe4c4302ea5204b7c22fc09068dadde6315b12a0d4e8a5c18af"
  end

  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build # for node-gyp
  depends_on "python@3.13" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "sqlite"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
    depends_on "terminal-notifier"
  end

  on_linux do
    depends_on "libsecret"
  end

  def install
    # Need node-addon-api v7+: https:github.comlovellsharpissues3920
    system "npm", "add", "node-addon-api@8.0.0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    node_notifier_vendor_dir = libexec"libnode_modulesjoplinnode_modulesnode-notifiervendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored terminal-notifier with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end
  end

  # All joplin commands rely on the system keychain and so they cannot run
  # unattended. The version command was specially modified in order to allow it
  # to be run in homebrew tests. Hence we test with `joplin version` here. This
  # does assert that joplin runs successfully on the environment.
  test do
    assert_match "joplin #{version}", shell_output("#{bin}joplin version")
  end
end