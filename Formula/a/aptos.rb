class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v4.2.2.tar.gz"
  sha256 "c0a845cbbc4bd43d556db599ba0ad65cf98f835f2593491e1d85db42682597f3"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "383a10d2d0e0e9ff03d4c994e7c830575c1d5f2d3ef7184a1f8aab0717aac8fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1235578eac1e6e0541b432f563d13dfdb0d9fce6fd9326e3a5aa722da3d7afc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afbba60ab7449bf52e444b960d6ed35c279362cbcabd7f67c24ee41eff1f2a9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9631f242d87e8898ebbc6dc8aeec5f88b0577026572f0d02aeea3de44d9d1e42"
    sha256 cellar: :any_skip_relocation, ventura:       "78c1c494a0af2ce2d2438dafa7fa0b72720ec69eb4f28b63c8b8acd1acc15ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a729432b4dcccf8e3a7753fe5b952d34d1cfed2730fb853dfeadc127c702c0b"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  # rust 1.80.0 build patch, upstream pr ref, https:github.comaptos-labsaptos-corepull14272
  patch do
    url "https:github.comaptos-labsaptos-corecommit72b9657316c699cfbef75216f578a0bd99e0be46.patch?full_index=1"
    sha256 "f93b4f8b0a61d245e13d6776834cec9ecdd3b0103d53b43dcc79cda3e3f787ed"
  end

  def install
    # FIXME: Look into a different way to specify extra RUSTFLAGS in superenv as they override .cargoconfig.toml
    # Ref: https:github.comHomebrewbrewblobmasterLibraryHomebrewextendENVsuper.rb#L65
    ENV.append "RUSTFLAGS", "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "cratesaptos"), "--profile=cli"
  end

  test do
    assert_match(output.pubi, shell_output("#{bin}aptos key generate --output-file output"))
  end
end