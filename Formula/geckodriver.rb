class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    # Get long hash via `https://hg.mozilla.org/mozilla-central/rev/<commit-short-hash>`
    hg_revision = "a80e5fd61076eda50fbf755f90bd30440ad12cc7"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.32.2"
    sha256 "0cc493ff77bb809e6925edd28baf6237b8e60950b7d3d2632847339bd1384b3e"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "70e571deb26b80ebf23984218ba253bcb329b10a02ce3e96ab84ba36214f52ea"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "55faf1bd9c8239cff541c6d7c92fb63c284543f90a6eb6ad934e506d4d3f115c"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "40b7cd177ae5f9a1f1d40232fca9c1d6d7538b8e0df535e851c0c4d93e07c659"
    end
  end

  livecheck do
    url "https://github.com/mozilla/geckodriver.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d0c45744dd60f777fb02273ba1159f384193f9b9a106d954b08d000f02a661c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f88e4127fe60f9b42399087dc20fa2b62efd6461e24ec3c1b0868fca999446b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07044048ac6710f4bfb5acdc4bd352e4ec1661c83cba1bbcb3dfcb28aad66db2"
    sha256 cellar: :any_skip_relocation, ventura:        "2b031372408a42a372fdacbabd913ecfe0f3a9de6eb2585e44c7d37c71b6792b"
    sha256 cellar: :any_skip_relocation, monterey:       "77421d81b6d70aed1809c7634aae1b613fa246b4cc49b654a0de34d68713bc2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "35927c34e0fd9201ec23c18a22e532afd62312bcf74a105d8ee4b8edf88d5007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c76adde0bb554e6c3e08391d1edf8006ba271c6f65345b0f79d71bb4631da5d0"
  end

  depends_on "rust" => :build

  uses_from_macos "netcat" => :test
  uses_from_macos "unzip"

  def install
    unless build.head?
      # we need to do this, because all archives are containing a top level testing directory
      %w[webdriver mozbase].each do |r|
        (buildpath/"staging").install resource(r)
        mv buildpath/"staging"/"testing"/r, buildpath/"testing"
        rm_rf buildpath/"staging"/"testing"
      end
      rm_rf buildpath/"staging"
      (buildpath/"testing"/"geckodriver").install resource("Cargo.lock")
    end

    cd "testing/geckodriver" do
      system "cargo", "install", *std_cargo_args
    end
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    test_port = free_port
    fork do
      exec "#{bin}/geckodriver --port #{test_port}"
    end
    sleep 2

    system "nc", "-z", "localhost", test_port
  end
end