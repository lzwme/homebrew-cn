class Perbase < Formula
  desc "Fast and correct perbase BAM/CRAM analysis"
  homepage "https://github.com/sstadick/perbase"
  url "https://ghfast.top/https://github.com/sstadick/perbase/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "01bbd8fb6ddc0b02347a068035b9a729a07cacfec12474d1fdb2501f086ca917"
  license "MIT"
  head "https://github.com/sstadick/perbase.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d0011baf280458e36b1bb746adce0e0308fc776b0dcc925454ae181ac0a91a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63b8475dff90ee750aae86701dfff7758616d96685c7d268fc35feb412352964"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29f0793dc1671b86287d7c17445d897ae54c2cb67e2afedfb4e0f89f82089add"
    sha256 cellar: :any_skip_relocation, sonoma:        "a95adcad8db198bac85d800563ac6dc9ce7945ca9dc0aae6c8dc39603ec0a5c0"
    sha256 cellar: :any_skip_relocation, ventura:       "25ce55f26cd47ca98156a14ed9062bc6e2c8129a337866b6a8bb8e77edc54637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54d23c8ae41638f14b17de1d96adb09c86a4cf88f32353ca702438a69d5d7893"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "bamtools" => :test

  on_linux do
    depends_on "openssl@3" # need to build `openssl-sys`
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/test.bam", testpath
    system Formula["bamtools"].opt_bin/"bamtools", "index", "-in", "test.bam"
    system bin/"perbase", "base-depth", "test.bam", "-o", "output.tsv"
    assert_path_exists "output.tsv"
  end
end