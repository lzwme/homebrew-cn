require "languagenode"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https:joplinapp.org"
  url "https:registry.npmjs.orgjoplin-joplin-3.0.1.tgz"
  sha256 "86217bd4b98a6a9e6b31ee3c716f6f83e2b90ff600bc436b47a428842494b5d4"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "7c23561c606fd689fb6557fe9492ee4cfd91fa65671649838d4d08e9c538b590"
    sha256                               arm64_ventura:  "ae900752b55e7c9f534f30d5c6c8e73aa708b968d9091844f78a63129f015f2a"
    sha256                               arm64_monterey: "ad732ce0027491099b535ea810f29afa113b9a47b5c70ff4d177893b2e96e243"
    sha256                               sonoma:         "dfab9e98f7525cc364e16e6369ec877927aca251900e5d72ba276d605ea5fab3"
    sha256                               ventura:        "8c51271183c0f6b374c353b145fdfc8cb0b64a6d14ac8c28fcafd6030827845a"
    sha256                               monterey:       "6a74e4b6448d14732a02e3bc3f00f06b14d6d438b5f03f5063529ca14dd556f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af8c54fbe05e626e923a8e68de949d83df5ad0cb62d473bcef0db1893d76c612"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build # for node-gyp
  depends_on "python@3.12" => :build
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
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

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