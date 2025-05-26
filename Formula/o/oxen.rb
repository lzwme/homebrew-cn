class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https:www.oxen.ai"
  url "https:github.comOxen-AIOxenarchiverefstagsv0.34.6.tar.gz"
  sha256 "2bb6fda065c25a04a4a15a7cbf6ec7fc8654e4214977e0387121c751af4b37f9"
  license "Apache-2.0"
  head "https:github.comOxen-AIOxen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e278af9c4c4c565bd97aa3b4b2cfcfff92da1be974cb990534d1a22e825cf3e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "058737b2b560bd432853d8b2fe15559c9e9e67c32da7a210e9d6faeaef7e4aaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4aabc64263f6166938d07971892faa08680c0c2f1f9067370092a41439991e65"
    sha256 cellar: :any_skip_relocation, sonoma:        "773433f917392ac71a870e3124778003f10400f4fb4d88578e1767b00a51772d"
    sha256 cellar: :any_skip_relocation, ventura:       "e0603a0f9d5f16e09b45085ea73609eea689e1dce228e2a59f824f58432fcc15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fb77184e1b027309b48161a936dcb893143707f89253bac9b9f80c4dcd320f5"
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