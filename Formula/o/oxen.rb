class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.36.3.tar.gz"
  sha256 "fa9744d1c5c0fe48a9e1c1dcb191a5aa7e193099aa7d2370cbfb049ed0f31bb4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b4e7b4fda97e6584944b80c07bade93b100fde8ccdca2ad271267d3c9582143"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80556835a1853e21d345afb8a9e4bf4d2d8d976772fac36871b8f460695b27c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e1a08f138f25485c78394fd44f2e80e573c6695a5edd7804ab22fdf31328b3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b378ccbb48e484dd2e4e3247f07c861ad36358e2c43da27589fad4bc5d6a48b1"
    sha256 cellar: :any_skip_relocation, ventura:       "ca241b13a38f903548706084a0320b7eb4bde6cc36fd174b5e5a479eeb957982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ddef465e9015fc35629e1bcbf556a4590275eef82cb4cc7e928e1c5518b127e"
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
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end