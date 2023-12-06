require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.13.2.tgz"
  sha256 "6e451a05708065b7f4f839449705452d2cf9dbe5f287ba5f0cf17511dae4d8ed"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "20bbb748587691595d4c963073a276c11c6db6decac333b12fc84db577dfe198"
    sha256                               arm64_monterey: "3e16f838c81a11af610447b85040fa23dd732f14d4a1d01fe6919cf1e5179837"
    sha256                               ventura:        "7ecee2fca173104484ad3ec85f799437dc0e80d35a12c11494b12e7330057b33"
    sha256                               monterey:       "146200af97c00fff909932ab89b4583c37900eeb08354c75f72705a4f0849aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba1c6ed7bcc37d1e75e1ebff0e1d2c4f6b1477bb58c95514c8a179d4f3e4887b"
  end

  depends_on "pkg-config" => :build
  depends_on "node"
  depends_on "sqlite"
  depends_on "vips"

  on_macos do
    depends_on "terminal-notifier"
  end

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_notifier_vendor_dir = libexec/"lib/node_modules/joplin/node_modules/node-notifier/vendor"
    node_notifier_vendor_dir.rmtree # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored terminal-notifier with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/joplin/node_modules/fsevents/fsevents.node"
  end

  # All joplin commands rely on the system keychain and so they cannot run
  # unattended. The version command was specially modified in order to allow it
  # to be run in homebrew tests. Hence we test with `joplin version` here. This
  # does assert that joplin runs successfully on the environment.
  test do
    assert_match "joplin #{version}", shell_output("#{bin}/joplin version")
  end
end