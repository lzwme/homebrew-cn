class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "ea2eebd12b735fd431c80b180e512baa816c9f3f1d11d94bf1ab22fbec6a1cde"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "489588e8a186ca1ac1c2a9708d1114fa8e0eebc0958c48322ef011c3e2f8b319"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e60f95e4cd567c774067f9aef8b69bea8561a8da490818c86876fa5e161904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6de9bfd32d4fae363691ffc679fd872add5b0b4f5d3df6abdb2c16615bcace28"
    sha256 cellar: :any_skip_relocation, sonoma:        "beaaa4cbbf549f4971e8d11ecaff71d2b0a3505ecb9bde579524b61a18b0dffa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ef31294e8fbd3a7cd37efbe9c138e44db4f935ac6c2eb79384ac246cc40c377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f388007ddec92bcfe552983650f304a826cffeca6346f0506bb5398490ad8fdb"
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