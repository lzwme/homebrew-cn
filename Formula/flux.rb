class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.194.0",
      revision: "f949299dab69138dc9863b1593de9bf1b11e0f5b"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "19b17783692343219df63de2a8b4b5f5891c92ac2e30a7ca902c94f889f820e4"
    sha256 cellar: :any,                 arm64_monterey: "daff22ff43c6272d4d7fd8899551881026d0af8071ee61cc39a43f230ef6c915"
    sha256 cellar: :any,                 arm64_big_sur:  "4d3dc57c8dad10ab77aa20efab6ead0e74f562a057a63596c898aa45a4e506be"
    sha256 cellar: :any,                 ventura:        "704624baa9dfa9d8991e9feacbd9f32984ed3d165fc39788fe48d756f8153476"
    sha256 cellar: :any,                 monterey:       "0fe1139ada2a44fbc5d32d6ea14dc3347fcb66de74a25585696c738da68b249b"
    sha256 cellar: :any,                 big_sur:        "cd4365480ad74d232bdbf01928219bcf3655ab0cfe439f0492ab6a6cd52dea0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a23fdd8b5e81d40aca1ede8cbe5d44a5fcb58b1f6a3c852f4d8661634ae6eec"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://ghproxy.com/https://github.com/influxdata/pkg-config/archive/v0.2.12.tar.gz"
    sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"

    livecheck do
      url "https://ghproxy.com/https://raw.githubusercontent.com/influxdata/flux/v#{LATEST_VERSION}/go.mod"
      regex(/pkg-config\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  def install
    # Set up the influxdata pkg-config wrapper to enable just-in-time compilation & linking
    # of the Rust components in the server.
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args(output: buildpath/"bootstrap/pkg-config")
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    system "make", "build"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flux"
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    (testpath/"test.flux").write <<~EOS
      1.0   + 2.0
    EOS
    system bin/"flux", "fmt", "--write-result-to-source", testpath/"test.flux"
    assert_equal "1.0 + 2.0\n", (testpath/"test.flux").read
  end
end