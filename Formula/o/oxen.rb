class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.36.4.tar.gz"
  sha256 "b71f5bcec47accebc9e6ae01d098a8fb1b95ffe79ea9d6fe0d474e9442c201f9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "182aad60df87258957b944aba66eda080b08c4bbfa36e55bdd1409d651ef6ca2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f29843f6c0b33bbb02c337670fc74a4dfffe09f523cfba8e4487dded6124df09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c86b8d3b69b2293813cd5e95db4196fbe918b38fc1c74340d2e823598758573b"
    sha256 cellar: :any_skip_relocation, sonoma:        "69cb73818d7deef88a32c77e60ef987082891050f5a37aa889af2e6735dfb227"
    sha256 cellar: :any_skip_relocation, ventura:       "ebc136a46782c4e5629887181e348aad3c38b6b2de2edc8e614d31d8b7f242f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9abaf56837d60b46ab995c95b56bd8ccaafbbb4b73a3f9449d9be764fd068671"
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