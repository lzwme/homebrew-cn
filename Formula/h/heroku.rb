class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.12.0.tgz"
  sha256 "99309413e94958db2c9c6e822f035d881ec50fecf64cd2c5cdae97d6a8809f1d"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "30c180342dac40418483dedecbc1d9dcf783b6c71438dc1b28b9f3f27fa503d4"
    sha256                               arm64_sonoma:  "6aaeefaff411572e6c4dc464d87a0dcf9470ff2295d8904476a3157d9c5dd46b"
    sha256                               arm64_ventura: "9cc2d8c78931761f2d3b49c4d86eb8377831a2f5e038e5a8146a407ef99e3bfd"
    sha256                               sonoma:        "6ef19ec4e97af592c0005a9dfcc08e2c47814820ca9b0b90723ff0fcf90fb9dd"
    sha256                               ventura:       "56d50a5423d410af990c95b9abb2ed2704bd905e767de79dd01b43937be7cbef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbb3c27880e3b0521a23685956feaf325e3e82bf294e99064b3f18fd16bd6748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "628da5407bd806bbf7326235418f467d10d4ffb1af9fa6a7edebb7fd892bb66f"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/heroku/node_modules"
    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = node_modules/"node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end