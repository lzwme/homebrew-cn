class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v3.5.1.tar.gz"
  sha256 "172e9332d240ab20641b8ca20f7bfd2df9350f505355185fd4db9ebb4e7cdd96"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f023f1ce37aabef6226026e8853b2abd64c9e0bdf30498de865c0778762e869b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7b33be900aa7ee1a65d9a623397b82a9d89d08d1c38f155c973a480c670aedb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14a4dc335ac61f7dddf0eaa0a3b6f2d879105acb15e24c5cad4586f8fbcecec2"
    sha256 cellar: :any_skip_relocation, sonoma:         "fecad063e7ac76641f6e604a6467f177792fa5aeb980936b1de105c09bee449a"
    sha256 cellar: :any_skip_relocation, ventura:        "386b757a8acdc4ae3f4d6f17a3c797f6d62ca6763025cfbd15fc6943179d35d5"
    sha256 cellar: :any_skip_relocation, monterey:       "2328a6b883ed4f8b0367066caa8a04c18ccdec493b2cfdfc9c0050f9ae83e866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dc31af4a6ad2695b6a90878047fdfd63cf3ab56b893acd0aeb57130e1813b9a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    # FIXME: Figure out why cargo doesn't respect .cargoconfig.toml's rustflags
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "cratesaptos"), "--profile=cli"
  end

  test do
    assert_match(output.pubi, shell_output("#{bin}aptos key generate --output-file output"))
  end
end