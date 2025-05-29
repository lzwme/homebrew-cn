class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https:www.oxen.ai"
  url "https:github.comOxen-AIOxenarchiverefstagsv0.34.7.tar.gz"
  sha256 "f830c146b2c5b93d0c0b94ddad03ac10d6dbf9b4eb39297bd4b914ff9076e179"
  license "Apache-2.0"
  head "https:github.comOxen-AIOxen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "308c4e9b10b4f4504ca2970baea5b518f96e3770a814c8da40ef96f4c29992d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f8614beac1f930c3b5aa9fb3b500d13498c3f335e064cfb7dfbd9d7ef7f588c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aafaaff87750438c8c1386acfcf298c86020efa9fb034db390f7566afeba4bf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8336f2b93dc0d97cb20576cfb2004d7ba67f4c4b8ffdb5db1bd8604f628721a2"
    sha256 cellar: :any_skip_relocation, ventura:       "2ba25b20500f7fd7ab49dd5cb3f73d069d62d26acbb20ae7f2a9e943c659ac58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6019a6c82e0fda3ce82deee832e65a7116a4d7ba17499c126b1ccc12c8626cff"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}oxen --version")

    system bin"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath".configoxenauth_config.toml").read
  end
end