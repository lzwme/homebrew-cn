require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.13.1.tgz"
  sha256 "d15c88cd7a9e01eb602459aacdaaed0cc004105fea9de177aff10307703bccd8"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "0bb164baf4416e66c00c93ebd506845538351021861259fd706ca1a549e70e5e"
    sha256                               arm64_monterey: "f2206768c7032ecf192280c462988f52223a5963c713110ef68729a7e6b4ad2e"
    sha256                               ventura:        "b6cfad372b6240bad59899dde464c8a7a5256871c152d82add54b437263b8820"
    sha256                               monterey:       "7fd151095bcb657c22bec1a62500b294ed8b1052022528a7f12a165f542f16d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11f480d3182b00ad4d51130523942d3e2aea356b88e71669418d020702290c8f"
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