class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "30fcc9460818fefb7afb92ea9b3c99c3f8735df82d0416286cc976e6e053cbac"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b39a098c0cf97e3c375f2443b401d83c30e71aabde9d6307cdc4c9668a5748b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5670a85f293a3acae963062758b46f19d4ec6a7fb810aa33e36235a412bb51d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8577662d5200daf1496c9666e798766d0f9a57798f7bb4174db738cb7fffb6a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe763750a5183605bedadb1697d9571849236c5191b4c90edb905422f22ebff4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be7e10f68944e2e6ae1139ccdf6974ccd6f1ba2ea41e801536586c49a0cd9586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea3751fa7ccdc53e1f74b1f08191eb33b87ba27b42e237a52093810830c648a"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end