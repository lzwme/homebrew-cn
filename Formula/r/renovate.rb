class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.149.0.tgz"
  sha256 "45e35903de13efe148c12784a03a5e43b460a9c2acce64a3125b02317e70fcdd"
  license "AGPL-3.0-only"

  # livecheck needs to surface multiple versions for version throttling but
  # there are thousands of renovate releases on npm. The package page showing
  # versions is several MB in size (and the registry response is 10x that),
  # so curl can time out before the response finishes. This checks releases on
  # GitHub as a workaround, as it provides information on multiple versions
  # but has a much smaller size.
  livecheck do
    url :homepage
    strategy :github_releases
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "849ea37c209e450aae7178754422825afa2c74c685e4165b12fc9efb8c886ebf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "849ea37c209e450aae7178754422825afa2c74c685e4165b12fc9efb8c886ebf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "849ea37c209e450aae7178754422825afa2c74c685e4165b12fc9efb8c886ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce54c8d41dc49ad4e335f5c2520986adf163318dff6845699cb1c14d40443249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ce54c8d41dc49ad4e335f5c2520986adf163318dff6845699cb1c14d40443249"
  end

  depends_on "node@24"

  uses_from_macos "git", since: :monterey # needs git >= 2.33.0 (Apple Git-136)

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Renovate filters child env vars, so Homebrew's git shim cannot run.
    ENV.remove "PATH", HOMEBREW_SHIMS_PATH/"shared"
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end