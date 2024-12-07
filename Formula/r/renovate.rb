class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.56.0.tgz"
  sha256 "c5bb5d16ca82601b1599a38370e3e9f228895e89ae0443a991f4452cbbadd224"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "051e89adce76ca6ad0953c52ba6334b83d673ad43e29b4aef4b76194e52b79a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b98e5733aa7e1a858835886e9e897418fbd3799038d4bbc282089378c504c8e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2a575d0b6a08b0015b668dffc958505184f80a4158e772841ad40676779df36"
    sha256 cellar: :any_skip_relocation, sonoma:        "db0c3e802ecff616d8dee0b99fdf84b8739d9472db2378a37c0496dc0431c0c3"
    sha256 cellar: :any_skip_relocation, ventura:       "2807cd2c1070f8dc12836981d41ba5fe641f4e03dfce8837aeee79d7cf1bf9f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "832f8d8edef131ac90376d956af463acf111c6f11bf9c09b8f7710687ee0a33a"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end