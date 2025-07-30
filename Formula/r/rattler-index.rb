class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.24.7.tar.gz"
  sha256 "a4614076f0ac24bdb27c7d7c9f78af1890c71133083c6e8f34bd1e51abdebf83"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49ae3be81db364c65492be27e18f9b1883e3dd980bf20fe46240d73da8280800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a51c8caf7a01d162e2f4510b24462ee2ed47beea43e1b80c78f8d591bab2149e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8f8880b685768b61af61064d6f9c86f41f5eebc57a968b9bd7456ace34dd7b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e715782cdc46753e9d56bd945ffcc3c0836833d2a9d85fd0cc38dcace080898"
    sha256 cellar: :any_skip_relocation, ventura:       "f1ae5828008217692bcb398e069432b64c8389f9710339b69fd6be580a0c068f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "157c0e2a1514f8df85d108ff7dbedf0b6219f410ca33292c9e3fd324c3e32306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3608afaac905c1f04156e6e6099442f82920bec0d887c47455074eae111329c2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls,rattler_config", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end