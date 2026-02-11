class RunKit < Formula
  desc "Universal multi-language runner and smart REPL"
  homepage "https://github.com/Esubaalew/run"
  url "https://ghfast.top/https://github.com/Esubaalew/run/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "c6193dadf1b9bc5a2ef3f04117b0155c4a46fce5bfa26775c80937bcc54ec82f"
  license "Apache-2.0"
  head "https://github.com/Esubaalew/run.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59425600697d42df0cbe1fcc84ee8659886fd1daff82d1e09bedcad6eb0a888c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "472c93de740952aab9c27ee423f85b5fac0a9a3ea5dc48ab4a3efe4f9119a167"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3dd508261528a010e99a5505c1bc259d63ac1e4bfc766548574dbde8e3a47f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c2d201cda7b3eccad0e5d30a7f1d55ad39b75ee25e522461a185561d6a316b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94ba7426f72a4f53ac293cf474d16a77130f34352b35cbeca9214c50bc9e44cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbc305018fadd7dc6c785902373763f8e6ebffaf2e64b7ba41128b9abe322bc1"
  end

  depends_on "rust" => :build

  conflicts_with "run", because: "both install a `run` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "brew", shell_output("#{bin}/run bash \"echo brew\"")
  end
end