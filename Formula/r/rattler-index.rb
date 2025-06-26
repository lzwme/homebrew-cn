class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https:github.comcondarattler"
  url "https:github.comcondarattlerarchiverefstagsrattler_index-v0.24.0.tar.gz"
  sha256 "385187a75dd8740f243b53b835957f2ed363f68c1267b58b7600bcf20305afd2"
  license "BSD-3-Clause"
  head "https:github.comcondarattler.git", branch: "main"

  livecheck do
    url :stable
    regex(^rattler_index-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08571e85fa0d379dd264f72b52d90a7db4bb15530a04c1a51c2dc0520ec0d8ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a5a0e0f6cafb83a825b413a365dab3efc4617dd3e0acfc1631291d324c364f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ff8d58c771ecd709acfcb57a59d720db88c3e989e63cd897b68aff71ca40626"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f81fc0cbf02a8e2aaa7d8a2aae209c0da97f778adf83369ef62d57742cfae08"
    sha256 cellar: :any_skip_relocation, ventura:       "fb5d56d1e376052f85d33d62d7e4162b089803d7d634375206ff146c3942998c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cba3e84aa3e0026aac14318df5546a5d12921e12a483d83ac0105587bc063630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8e91fc5bce82b4648f16cc0dde76ab37d107048fc8fef59330c020caede4b6f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls,rattler_config", "--no-default-features",
        *std_cargo_args(path: "cratesrattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}rattler-index --version").strip

    system bin"rattler-index", "fs", "."
    assert_path_exists testpath"noarchrepodata.json"
  end
end